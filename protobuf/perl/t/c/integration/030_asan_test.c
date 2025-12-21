#include "t/c/upb-perl-test.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <errno.h>

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

void xs_init(pTHX);

// This function is expected to crash due to ASan detected error
void child_process_crash() {
    fprintf(stderr, "# CHILD: ASan Test: About to cause heap-buffer-overflow\n");
    fflush(stderr);
    char *buffer = (char*)malloc(5);
    if (buffer) {
        strcpy(buffer, "This string is way too long"); // Overflow
        fprintf(stderr, "# CHILD: Should not reach here after strcpy\n");
        free(buffer);
    } else {
        fprintf(stderr, "# CHILD: malloc failed\n");
    }
    fprintf(stderr, "# CHILD: Should not reach here\n");
    fflush(stderr);
}

int main(int argc, char** argv) {
    PERL_SYS_INIT(&argc, &argv);
    PerlInterpreter *my_perl = perl_alloc();
    perl_construct(my_perl);
    PL_exit_flags |= PERL_EXIT_DESTRUCT_END;
    char *embedding[] = { (char*)"", (char*)"-e", "0", NULL };
    perl_parse(my_perl, xs_init, 3, embedding, NULL);
    perl_run(my_perl);

    plan(3); // 1. fork ok, 2. child exit status, 3. stderr content

    int pipefd[2];
    if (pipe(pipefd) == -1) {
        perror("pipe");
        fail("Failed to create pipe");
        return 1;
    }

    pid_t pid = fork();
    if (pid == -1) {
        perror("fork");
        fail("Failed to fork");
        return 1;
    } else if (pid == 0) {
        // Child process
        close(pipefd[0]);    // Close unused read end
        dup2(pipefd[1], STDERR_FILENO); // Redirect stderr to pipe
        close(pipefd[1]);    // Close original write end

        child_process_crash();
        exit(0); // Should not be reached
    } else {
        // Parent process
        close(pipefd[1]);    // Close unused write end

        char child_stderr[4096] = {0};
        ssize_t bytes_read = read(pipefd[0], child_stderr, sizeof(child_stderr) - 1);
        close(pipefd[0]);

        if (bytes_read > 0) {
            cdiag("Child stderr:\n%s", child_stderr);
        } else {
            cdiag("Child stderr: (empty or read error)");
        }

        int status;
        waitpid(pid, &status, 0);

        ok(1, "Fork and wait completed");

        if (WIFEXITED(status)) {
            fail(sdiagnostic("Child exited with %d, expected crash", WEXITSTATUS(status)));
        } else if (WIFSIGNALED(status)) {
            ok(1, sdiagnostic("Child terminated by signal %d (as expected)", WTERMSIG(status)));
        } else {
            fail("Child status unknown");
        }

        like(child_stderr, "HEAP BUFFER OVERFLOW", "ASan detected heap-buffer-overflow");
    }

    perl_destruct(my_perl);
    perl_free(my_perl);
    PERL_SYS_TERM();
    return 0;
}

void xs_init(pTHX) { /* Empty */ }
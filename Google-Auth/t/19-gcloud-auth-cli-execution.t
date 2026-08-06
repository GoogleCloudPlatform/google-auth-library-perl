#!/usr/bin/env perl
# Copyright 2026 Google LLC and contributors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

use strict;
use warnings;
use Test::More;
use Capture::Tiny qw(capture);

# 1. Load Log::Any::Test FIRST
use Log::Any::Test;

# 2. Load Log::Any
use Log::Any qw($log);

# 3. Load the Adapter
use Log::Any::Adapter;

# 4. Set the Test adapter before running script
Log::Any::Adapter->set('Test', min_level => 'trace');

# 5. Load modules under test
use Google::Auth;
use File::Temp qw(tempfile);

# Require the script but don't run it immediately
use File::Spec;
use File::Basename;
use Cwd 'abs_path';
my $script_path = abs_path(File::Spec->catfile(dirname(__FILE__), '..', 'bin', 'gcloud-auth.pl'));
require $script_path;

# Create dummy client id file
my ($fh, $client_id_file) = tempfile();
print $fh '{"installed":{"client_id":"mock_id","client_secret":"mock_secret"}}';
close $fh;

subtest 'gcloud-auth login script execution (Timeout)' => sub {
    $log->clear();
    
    my ($stdout, $stderr, @result) = capture {
        eval { run('login', '--client-id-file', $client_id_file); };
    };
    
    # Verify logs captured by Log::Any::Test
    $log->contains_ok(qr/Command: login initiated/, 'Logged login init');
    $log->contains_ok(qr/Entering do_login/, 'Logged entering login');
    $log->contains_ok(qr/Timeout waiting for authorization code/, 'Logged timeout');
    
    # Verify it died as expected
    ok($@, 'Script threw exception on timeout');
    like($@, qr/Timeout waiting for authorization code/, 'Die message matches timeout');
};

subtest 'gcloud-auth adc login script execution' => sub {
    $log->clear();
    
    my ($stdout, $stderr, @result) = capture {
        run('application-default', 'login');
    };
    
    $log->contains_ok(qr/Command: application-default login initiated/, 'Logged adc login init');
    $log->contains_ok(qr/Entering do_adc_login/, 'Logged entering adc login');
    $log->contains_ok(qr/Leaving do_adc_login/, 'Logged leaving adc login');
};

done_testing();

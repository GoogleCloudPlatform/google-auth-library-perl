package Google::Rpc::ErrorDetails::Types;

use strict;
use warnings;

use Type::Library -base;
use Type::Utils -all;
use Types::Standard -types;

declare 'ErrorInfo',
    as InstanceOf['Google::Rpc::ErrorDetails::ErrorInfo'];

coerce 'ErrorInfo',
    from HashRef, via { 'Google::Rpc::ErrorDetails::ErrorInfo'->new($_) };

declare 'RepeatedErrorInfo',
    as ArrayRef[ErrorInfo()];

coerce 'RepeatedErrorInfo',
    from ArrayRef[HashRef], via { [ map { 'Google::Rpc::ErrorDetails::ErrorInfo'->new($_) } @$_ ] };

declare 'MapStringErrorInfo',
    as HashRef[ErrorInfo()];

declare 'MetadataEntry',
    as InstanceOf['Google::Rpc::ErrorDetails::ErrorInfo::MetadataEntry'];

coerce 'MetadataEntry',
    from HashRef, via { 'Google::Rpc::ErrorDetails::ErrorInfo::MetadataEntry'->new($_) };

declare 'RepeatedMetadataEntry',
    as ArrayRef[MetadataEntry()];

coerce 'RepeatedMetadataEntry',
    from ArrayRef[HashRef], via { [ map { 'Google::Rpc::ErrorDetails::ErrorInfo::MetadataEntry'->new($_) } @$_ ] };

declare 'MapStringMetadataEntry',
    as HashRef[MetadataEntry()];

declare 'RetryInfo',
    as InstanceOf['Google::Rpc::ErrorDetails::RetryInfo'];

coerce 'RetryInfo',
    from HashRef, via { 'Google::Rpc::ErrorDetails::RetryInfo'->new($_) };

declare 'RepeatedRetryInfo',
    as ArrayRef[RetryInfo()];

coerce 'RepeatedRetryInfo',
    from ArrayRef[HashRef], via { [ map { 'Google::Rpc::ErrorDetails::RetryInfo'->new($_) } @$_ ] };

declare 'MapStringRetryInfo',
    as HashRef[RetryInfo()];

declare 'DebugInfo',
    as InstanceOf['Google::Rpc::ErrorDetails::DebugInfo'];

coerce 'DebugInfo',
    from HashRef, via { 'Google::Rpc::ErrorDetails::DebugInfo'->new($_) };

declare 'RepeatedDebugInfo',
    as ArrayRef[DebugInfo()];

coerce 'RepeatedDebugInfo',
    from ArrayRef[HashRef], via { [ map { 'Google::Rpc::ErrorDetails::DebugInfo'->new($_) } @$_ ] };

declare 'MapStringDebugInfo',
    as HashRef[DebugInfo()];

declare 'QuotaFailure',
    as InstanceOf['Google::Rpc::ErrorDetails::QuotaFailure'];

coerce 'QuotaFailure',
    from HashRef, via { 'Google::Rpc::ErrorDetails::QuotaFailure'->new($_) };

declare 'RepeatedQuotaFailure',
    as ArrayRef[QuotaFailure()];

coerce 'RepeatedQuotaFailure',
    from ArrayRef[HashRef], via { [ map { 'Google::Rpc::ErrorDetails::QuotaFailure'->new($_) } @$_ ] };

declare 'MapStringQuotaFailure',
    as HashRef[QuotaFailure()];

declare 'Violation',
    as InstanceOf['Google::Rpc::ErrorDetails::QuotaFailure::Violation'];

coerce 'Violation',
    from HashRef, via { 'Google::Rpc::ErrorDetails::QuotaFailure::Violation'->new($_) };

declare 'RepeatedViolation',
    as ArrayRef[Violation()];

coerce 'RepeatedViolation',
    from ArrayRef[HashRef], via { [ map { 'Google::Rpc::ErrorDetails::QuotaFailure::Violation'->new($_) } @$_ ] };

declare 'MapStringViolation',
    as HashRef[Violation()];

declare 'QuotaDimensionsEntry',
    as InstanceOf['Google::Rpc::ErrorDetails::QuotaFailure::Violation::QuotaDimensionsEntry'];

coerce 'QuotaDimensionsEntry',
    from HashRef, via { 'Google::Rpc::ErrorDetails::QuotaFailure::Violation::QuotaDimensionsEntry'->new($_) };

declare 'RepeatedQuotaDimensionsEntry',
    as ArrayRef[QuotaDimensionsEntry()];

coerce 'RepeatedQuotaDimensionsEntry',
    from ArrayRef[HashRef], via { [ map { 'Google::Rpc::ErrorDetails::QuotaFailure::Violation::QuotaDimensionsEntry'->new($_) } @$_ ] };

declare 'MapStringQuotaDimensionsEntry',
    as HashRef[QuotaDimensionsEntry()];

declare 'PreconditionFailure',
    as InstanceOf['Google::Rpc::ErrorDetails::PreconditionFailure'];

coerce 'PreconditionFailure',
    from HashRef, via { 'Google::Rpc::ErrorDetails::PreconditionFailure'->new($_) };

declare 'RepeatedPreconditionFailure',
    as ArrayRef[PreconditionFailure()];

coerce 'RepeatedPreconditionFailure',
    from ArrayRef[HashRef], via { [ map { 'Google::Rpc::ErrorDetails::PreconditionFailure'->new($_) } @$_ ] };

declare 'MapStringPreconditionFailure',
    as HashRef[PreconditionFailure()];

declare 'Violation',
    as InstanceOf['Google::Rpc::ErrorDetails::PreconditionFailure::Violation'];

coerce 'Violation',
    from HashRef, via { 'Google::Rpc::ErrorDetails::PreconditionFailure::Violation'->new($_) };

declare 'RepeatedViolation',
    as ArrayRef[Violation()];

coerce 'RepeatedViolation',
    from ArrayRef[HashRef], via { [ map { 'Google::Rpc::ErrorDetails::PreconditionFailure::Violation'->new($_) } @$_ ] };

declare 'MapStringViolation',
    as HashRef[Violation()];

declare 'BadRequest',
    as InstanceOf['Google::Rpc::ErrorDetails::BadRequest'];

coerce 'BadRequest',
    from HashRef, via { 'Google::Rpc::ErrorDetails::BadRequest'->new($_) };

declare 'RepeatedBadRequest',
    as ArrayRef[BadRequest()];

coerce 'RepeatedBadRequest',
    from ArrayRef[HashRef], via { [ map { 'Google::Rpc::ErrorDetails::BadRequest'->new($_) } @$_ ] };

declare 'MapStringBadRequest',
    as HashRef[BadRequest()];

declare 'FieldViolation',
    as InstanceOf['Google::Rpc::ErrorDetails::BadRequest::FieldViolation'];

coerce 'FieldViolation',
    from HashRef, via { 'Google::Rpc::ErrorDetails::BadRequest::FieldViolation'->new($_) };

declare 'RepeatedFieldViolation',
    as ArrayRef[FieldViolation()];

coerce 'RepeatedFieldViolation',
    from ArrayRef[HashRef], via { [ map { 'Google::Rpc::ErrorDetails::BadRequest::FieldViolation'->new($_) } @$_ ] };

declare 'MapStringFieldViolation',
    as HashRef[FieldViolation()];

declare 'RequestInfo',
    as InstanceOf['Google::Rpc::ErrorDetails::RequestInfo'];

coerce 'RequestInfo',
    from HashRef, via { 'Google::Rpc::ErrorDetails::RequestInfo'->new($_) };

declare 'RepeatedRequestInfo',
    as ArrayRef[RequestInfo()];

coerce 'RepeatedRequestInfo',
    from ArrayRef[HashRef], via { [ map { 'Google::Rpc::ErrorDetails::RequestInfo'->new($_) } @$_ ] };

declare 'MapStringRequestInfo',
    as HashRef[RequestInfo()];

declare 'ResourceInfo',
    as InstanceOf['Google::Rpc::ErrorDetails::ResourceInfo'];

coerce 'ResourceInfo',
    from HashRef, via { 'Google::Rpc::ErrorDetails::ResourceInfo'->new($_) };

declare 'RepeatedResourceInfo',
    as ArrayRef[ResourceInfo()];

coerce 'RepeatedResourceInfo',
    from ArrayRef[HashRef], via { [ map { 'Google::Rpc::ErrorDetails::ResourceInfo'->new($_) } @$_ ] };

declare 'MapStringResourceInfo',
    as HashRef[ResourceInfo()];

declare 'Help',
    as InstanceOf['Google::Rpc::ErrorDetails::Help'];

coerce 'Help',
    from HashRef, via { 'Google::Rpc::ErrorDetails::Help'->new($_) };

declare 'RepeatedHelp',
    as ArrayRef[Help()];

coerce 'RepeatedHelp',
    from ArrayRef[HashRef], via { [ map { 'Google::Rpc::ErrorDetails::Help'->new($_) } @$_ ] };

declare 'MapStringHelp',
    as HashRef[Help()];

declare 'Link',
    as InstanceOf['Google::Rpc::ErrorDetails::Help::Link'];

coerce 'Link',
    from HashRef, via { 'Google::Rpc::ErrorDetails::Help::Link'->new($_) };

declare 'RepeatedLink',
    as ArrayRef[Link()];

coerce 'RepeatedLink',
    from ArrayRef[HashRef], via { [ map { 'Google::Rpc::ErrorDetails::Help::Link'->new($_) } @$_ ] };

declare 'MapStringLink',
    as HashRef[Link()];

declare 'LocalizedMessage',
    as InstanceOf['Google::Rpc::ErrorDetails::LocalizedMessage'];

coerce 'LocalizedMessage',
    from HashRef, via { 'Google::Rpc::ErrorDetails::LocalizedMessage'->new($_) };

declare 'RepeatedLocalizedMessage',
    as ArrayRef[LocalizedMessage()];

coerce 'RepeatedLocalizedMessage',
    from ArrayRef[HashRef], via { [ map { 'Google::Rpc::ErrorDetails::LocalizedMessage'->new($_) } @$_ ] };

declare 'MapStringLocalizedMessage',
    as HashRef[LocalizedMessage()];

1;

__END__

=head1 NAME

Google::Rpc::ErrorDetails::Types - Type definitions and coercions

=head1 DESCRIPTION

Auto-generated Type::Tiny definitions and coercions for Protocol Buffers.

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2026 Google LLC

This program is released under the Apache 2.0 license.

=cut

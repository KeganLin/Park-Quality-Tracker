create table if not exists quality_reports (
    id bigserial primary key,
    park_name text not null,
    issue_type text not null,
    severity integer not null check (severity between 1 and 5),
    notes text,
    reported_by text not null,
    reported_at timestamp with time zone default now()
);
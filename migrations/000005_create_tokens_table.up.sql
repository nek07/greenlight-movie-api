CREATE TABLE IF NOT EXISTS tokens (
    hash bytea PRIMARY KEY,
    user_id bigint NOT NULL REFERENCES users ON DELETE CASCADE,
    EXPIRY TIMESTAMP(0) with time zone NOT NULL,
    scope text NOT NULL
);
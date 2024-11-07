CREATE TABLE IF NOT EXISTS users (
    id bigserial PRIMARY KEY, 
    created_at timestamp(0) with time zone NOT NULL DEFAULT NOW(),
    name text NOT NULL,
    email citext UNIQUE NOT NULL,  -- case insensitive text
    password_hash bytea NOT NULL, -- binary string - one way hash using bcrypt
    activated bool NOT NULL,
    version integer NOT NULL DEFAULT 1
);

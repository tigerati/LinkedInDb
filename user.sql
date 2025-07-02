CREATE OR REPLACE FUNCTION register_user(
    full_name VARCHAR,
    address VARCHAR,
    email VARCHAR,
    password_hash VARCHAR,
    profile_pic VARCHAR,
    bio TEXT,
    created_at VARCHAR,
    user_type VARCHAR
)
RETURNS void AS
$$
    INSERT INTO tbl_user (
        full_name, address, email, password_hash,
        profile_pic, bio, created_at, user_type
    )
    VALUES (
        $1, $2, $3, $4,
        $5, $6, $7, $8
    );
$$ LANGUAGE SQL;
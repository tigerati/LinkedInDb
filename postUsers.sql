CREATE OR REPLACE FUNCTION create_post(
    author_id INT,
    content VARCHAR,
    media_url VARCHAR,
    visibility visibility_status  DEFAULT 'public'-- enum type now
)
RETURNS VOID AS
$$
BEGIN
    INSERT INTO Tbl_Post (
        author_id,
        content,
        media_url,
        visibility
    ) VALUES ($1, $2, $3, $4);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_repost(
    p_post_id INT,
    p_user_id INT,
    p_content TEXT,
    p_visibility visibility_status DEFAULT 'public'
)
    RETURNS VOID AS
$$
BEGIN
    -- Try to insert the repost; if it violates UNIQUE constraint, raise notice
    BEGIN
        INSERT INTO Tbl_repost (post_id, user_id, content, visibility)
        VALUES (p_post_id, p_user_id, p_content, p_visibility);
    EXCEPTION WHEN unique_violation THEN
        RAISE NOTICE 'User % has already reposted post %', p_user_id, p_post_id;
    END;
END;
$$ LANGUAGE plpgsql;


-- Function to delete a post by post_id
CREATE OR REPLACE FUNCTION delete_post(p_post_id INT)
RETURNS VOID AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Tbl_Post WHERE post_id = p_post_id) THEN
        DELETE FROM Tbl_Post WHERE post_id = p_post_id;
        RAISE NOTICE 'Post with ID % has been deleted.', p_post_id;
    ELSE
        RAISE NOTICE 'Post with ID % does not exist.', p_post_id;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION delete_repost(p_repost_id INT)
    RETURNS VOID AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Tbl_repost WHERE repost_id = p_repost_id) THEN
        DELETE FROM Tbl_repost WHERE repost_id = p_repost_id;
        RAISE NOTICE 'Post with ID % has been deleted.', p_repost_id;
    ELSE
        RAISE NOTICE 'Post with ID % does not exist.', p_repost_id;
    END IF;
END;
$$ LANGUAGE plpgsql;

create or replace function comment_post(
    post_id int,
    author_id int,
    content varchar,
    media_url varchar
)
returns void AS
$$
BEGIN

END;
$$ LANGUAGE plpgsql;

create or replace function create_comment(
    _post_id int,
    _user_id int,
    _content varchar,
    _media_url varchar,
    _visibility bool
)
returns void AS
$$
BEGIN
    insert into tbl_comment(
        post_id, user_id, content, media_url, visibility
    )
    values($1,$2,$3,$4,$5);
END;
$$ LANGUAGE plpgsql;
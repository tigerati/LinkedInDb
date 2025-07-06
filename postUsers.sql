create or replace function create_post(
    author_id int,
    content varchar,
    media_url varchar,
    visibility bool
)
returns void as
$$
BEGIN
    insert into tbl_post(
        author_id,
        content,
        media_url,
        visibility)
    values ($1, $2, $3, $4);
END;
$$ language plpgsql;

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
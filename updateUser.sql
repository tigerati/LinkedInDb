create or replace function update_profile(
    _profile_id int,
    _user_id int,
    _website varchar,
    _linkedin_url varchar
)
returns void as
$$
BEGIN
    update tbl_profile
    set website = _website, linkedin_url = _linkedin_url
    where profile_id = _profile_id and user_id = _user_id;
END;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION update_post(
    _post_id int,
    _author_id int,
    _content varchar,
    _media_url varchar,
    _visibility bool
)
RETURNS void AS
$$
BEGIN
    -- Attempt update
    UPDATE tbl_post
    SET content = _content,
        media_url = _media_url,
        visibility = _visibility
    WHERE post_id = _post_id AND author_id = _author_id;

    -- Check if update affected any rows
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Post ID % or Author ID % does not exist.', _post_id, _author_id;
    END IF;
END;
$$ LANGUAGE plpgsql;
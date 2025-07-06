create or replace function update_comment(
    _comment_id int,
    _post_id int,
    _user_id int,
    _content varchar
)
returns void as
$$
BEGIN
    update tbl_comment
    set content = _content
    where comment_id = _comment_id and post_id = _post_id
    and user_id = _user_id;
END;
$$ language plpgsql;

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

-- Function to update a post by post_id
CREATE OR REPLACE FUNCTION update_post(
    p_post_id INT,
    p_content VARCHAR,
    p_media_url VARCHAR,
    p_visibility BOOLEAN
)
RETURNS VOID AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Tbl_Post WHERE post_id = p_post_id) THEN
        UPDATE Tbl_Post
        SET content = p_content,
            media_url = p_media_url,
            visibility = p_visibility
        WHERE post_id = p_post_id;

        RAISE NOTICE 'Post % has been updated.', p_post_id;
    ELSE
        RAISE NOTICE 'Post % does not exist.', p_post_id;
    END IF;
END;
$$ LANGUAGE plpgsql;

create or replace function update_education(
    _edu_id int,
    _user_id int,
    _school_name varchar default null,
    _degree varchar default null,
    _field_of_study varchar default null,
    _start_year int default null,
    _end_year int default null
)
returns void as
$$
BEGIN
    update tbl_education
    set school_name = _school_name,
        degree = _degree,
        field_of_study = _field_of_study,
        start_year = _start_year,
        end_year = _end_year
    where edu_id = _edu_id and user_id = _user_id;
END;
$$ LANGUAGE plpgsql;
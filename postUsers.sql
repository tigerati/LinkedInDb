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
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
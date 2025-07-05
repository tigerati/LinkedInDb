create or replace function create_conversation(
    _user1_id int,
    _user2_id int
)
returns void AS
$$
BEGIN
    insert into tbl_conversation(
        user1_id, user2_id
    )
    values($1,$2);
END;
$$ language plpgsql;
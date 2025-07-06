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

create or replace function send_message(
    _conversation_id int,
    _sender_id int,
    _content varchar
)
returns void as
$$
begin
    insert into tbl_message(
        conversation_id, sender_id, content
    )
    values($1,$2,$3);
END;
$$ language plpgsql;

create or replace function update_message(
    _msg_id int,
    _conversation_id int,
    _sender_id int,
    _content varchar
)
returns void AS
$$
BEGIN
    update tbl_message
    set content = _content
    where msg_id = _msg_id and conversation_id = _conversation_id
    and sender_id = _sender_id;
END;
$$ language plpgsql;

create or replace function delete_message(
    _msg_id int,
    _conversation_id int,
    _sender_id int
)
returns void AS
$$
BEGIN
    delete from tbl_message
    where msg_id = _msg_id and conversation_id = _conversation_id
    and sender_id = _sender_id;
END;
$$ language plpgsql;
-- delete user function (also affects other tables
-- that reference tbl_user)
create or replace function delete_user(
    _user_id int
)
returns void AS
$$
BEGIN
    delete from tbl_user where user_id = _user_id;
END;
$$ language plpgsql;

create or replace function delete_userSkill(
    _user_id int,
    _skill_id int
)
returns void AS
$$
BEGIN
    delete from tbl_userskill
    where user_id = _user_id and skill_id = _skill_id;
END;
$$ language plpgsql;


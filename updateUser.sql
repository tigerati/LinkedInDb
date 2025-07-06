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
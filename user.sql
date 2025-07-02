CREATE OR REPLACE FUNCTION add_education(
    user_id INT,
    school_name VARCHAR,
    degree VARCHAR,
    field_of_study VARCHAR,
    start_year INT,
    end_year INT
)
RETURNS void AS
$$
    INSERT INTO tbl_education (
        user_id,
        school_name,
        degree,
        field_of_study,
        start_year,
        end_year
    )
    VALUES (
        $1, $2, $3, $4,
        $5, $6
    );
$$ LANGUAGE SQL;

select add_education(
       2,
       'Oxford',
       'Undergraduate',
       'Computer Science',
       2000,
       2004
       );

select * from tbl_education;

CREATE OR REPLACE FUNCTION add_experience(
    user_id INT,
    company_name VARCHAR,
    title VARCHAR,
    start_date DATE,
    end_date DATE,
    description TEXT
)
RETURNS void AS
$$
    INSERT INTO tbl_experience (
        user_id,
        company_name,
        title,
        start_date,
        end_date,
        description
    )
    VALUES (
        $1, $2, $3, $4,
        $5, $6
    );
$$ LANGUAGE SQL;

select add_experience(
       2,
       'Nvidia',
       'Maid',
       '2005-11-01',
       '2005-11-02',
       'oiarhgoiahraorjgow'
       );

select * from tbl_experience;

insert into tbl_skill(skill_name) values ('Python'), ('SQL'), ('Java');

select * from tbl_skill;

CREATE OR REPLACE FUNCTION add_user_skill(
    _user_id INT,
    _skill_id INT
)
RETURNS TEXT AS
$$
BEGIN
    INSERT INTO tbl_userskill (user_id, skill_id)
    VALUES (_user_id, _skill_id);
    RETURN 'Skill added to user';
EXCEPTION
    WHEN unique_violation THEN
        RETURN 'This skill already exists for the user';
END;
$$ LANGUAGE plpgsql;

select add_user_skill(2, 1);

select * from tbl_userskill;

CREATE OR REPLACE FUNCTION add_user_skill_by_name(
    _user_id INT,
    _skill_name VARCHAR
)
RETURNS TEXT AS
$$
DECLARE
    _skill_id INT;
BEGIN
    -- Check if skill exists
    SELECT skill_id INTO _skill_id
    FROM tbl_skill
    WHERE skill_name = _skill_name;

    -- If not found, insert it
    IF NOT FOUND THEN
        INSERT INTO tbl_skill (skill_name)
        VALUES (_skill_name)
        RETURNING skill_id INTO _skill_id;
    END IF;

    -- Insert into UserSkill
    INSERT INTO tbl_userskill (user_id, skill_id)
    VALUES (_user_id, _skill_id);

    RETURN 'Skill added successfully';
EXCEPTION
    WHEN unique_violation THEN
        RETURN 'User already has this skill';
END;
$$ LANGUAGE plpgsql;
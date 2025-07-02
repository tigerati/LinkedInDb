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
    INSERT INTO tbl_user (
        full_name, address, email, password_hash,
        profile_pic, bio, created_at, user_type
    )
    VALUES (
        $1, $2, $3, $4,
        $5, $6, $7, $8
    );
$$ LANGUAGE SQL;
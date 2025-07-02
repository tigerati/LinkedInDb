CREATE TABLE Tbl_user (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    address VARCHAR(100),
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    profile_pic VARCHAR(255),
    bio TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_type VARCHAR(100) NOT NULL DEFAULT 'job_seeker',
    CHECK (user_type IN ('job_seeker', 'company'))
);


CREATE TABLE Tbl_Profile (
                             profile_id SERIAL PRIMARY KEY,
                             user_id INT NOT NULL,
                             website VARCHAR(255),
                             linkedin_url VARCHAR(255),
                             FOREIGN KEY (user_id) REFERENCES Tbl_user(user_id) ON DELETE CASCADE
);

CREATE TABLE Tbl_Connection (
                                user1_id INT NOT NULL,
                                user2_id INT NOT NULL,
                                status VARCHAR(100) NOT NULL,
                                connected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                PRIMARY KEY (user1_id, user2_id),
                                FOREIGN KEY (user1_id) REFERENCES Tbl_user(user_id) ON DELETE CASCADE,
                                FOREIGN KEY (user2_id) REFERENCES Tbl_user(user_id) ON DELETE CASCADE
);

CREATE TABLE Tbl_Post (
                          post_id SERIAL PRIMARY KEY,
                          author_id INT NOT NULL,
                          content VARCHAR(255),
                          media_url VARCHAR(255),
                          posted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          visibility BOOLEAN DEFAULT TRUE,
                          FOREIGN KEY (author_id) REFERENCES Tbl_user(user_id) ON DELETE CASCADE
);

CREATE TABLE Tbl_Reaction (
                              reaction_id SERIAL PRIMARY KEY,
                              post_id INT NOT NULL,
                              user_id INT NOT NULL,
                              reaction_type VARCHAR(100) NOT NULL,
                              reacted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                              FOREIGN KEY (post_id) REFERENCES Tbl_Post(post_id) ON DELETE CASCADE,
                              FOREIGN KEY (user_id) REFERENCES Tbl_user(user_id) ON DELETE CASCADE
);

CREATE TABLE Tbl_Comment (
                             comment_id SERIAL PRIMARY KEY,
                             post_id INT NOT NULL,
                             user_id INT NOT NULL,
                             content VARCHAR(255),
                             media_url VARCHAR(255),
                             posted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             visibility BOOLEAN DEFAULT TRUE,
                             FOREIGN KEY (post_id) REFERENCES Tbl_Post(post_id) ON DELETE CASCADE,
                             FOREIGN KEY (user_id) REFERENCES Tbl_user(user_id) ON DELETE CASCADE
);

CREATE TABLE Tbl_JobSeeker (
                               user_id INT PRIMARY KEY,
                               open_to_work BOOLEAN DEFAULT FALSE,
                               career_goal VARCHAR(100),
                               preferred_industry VARCHAR(100),
                               resume_url VARCHAR(255),
                               FOREIGN KEY (user_id) REFERENCES Tbl_user(user_id) ON DELETE CASCADE
);

CREATE TABLE Tbl_Education (
                               edu_id SERIAL PRIMARY KEY,
                               user_id INT NOT NULL,
                               school_name VARCHAR(100),
                               degree VARCHAR(100),
                               field_of_study VARCHAR(100),
                               start_year INT,
                               end_year INT,
                               FOREIGN KEY (user_id) REFERENCES Tbl_user(user_id) ON DELETE CASCADE
);

CREATE TABLE Tbl_Experience (
                                exp_id SERIAL PRIMARY KEY,
                                user_id INT NOT NULL,
                                company_name VARCHAR(100),
                                title VARCHAR(100),
                                start_date DATE,
                                end_date DATE,
                                description TEXT,
                                FOREIGN KEY (user_id) REFERENCES Tbl_user(user_id) ON DELETE CASCADE
);

CREATE TABLE Tbl_skill (
                           skill_id SERIAL PRIMARY KEY,
                           skill_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Tbl_UserSkill (
                               skill_id INT NOT NULL,
                               user_id INT NOT NULL,
                               PRIMARY KEY (user_id, skill_id),
                               FOREIGN KEY (user_id) REFERENCES Tbl_user(user_id) ON DELETE CASCADE,
                               FOREIGN KEY (skill_id) REFERENCES Tbl_skill(skill_id) ON DELETE CASCADE
);

CREATE TABLE Tbl_Company (
                             company_id SERIAL PRIMARY KEY,
                             user_id INT NOT NULL,
                             industry VARCHAR(100),
                             company_name VARCHAR(100) NOT NULL,
                             website VARCHAR(255),
                             address VARCHAR(255),
                             logo_url VARCHAR(255),
                             FOREIGN KEY (user_id) REFERENCES Tbl_user(user_id) ON DELETE CASCADE
);

CREATE TABLE Tbl_JobPost (
                             job_id SERIAL PRIMARY KEY,
                             company_id INT NOT NULL,
                             title VARCHAR(100),
                             description TEXT,
                             address VARCHAR(255),
                             posted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             employment_type VARCHAR(255),
                             salary_range VARCHAR(100),
                             FOREIGN KEY (company_id) REFERENCES Tbl_Company(company_id) ON DELETE CASCADE
);

CREATE TABLE Tbl_Application (
                                 application_id SERIAL PRIMARY KEY,
                                 user_id INT NOT NULL,
                                 job_id INT NOT NULL,
                                 status VARCHAR(100),
                                 applied_date DATE DEFAULT CURRENT_DATE,
                                 FOREIGN KEY (user_id) REFERENCES Tbl_user(user_id) ON DELETE CASCADE,
                                 FOREIGN KEY (job_id) REFERENCES Tbl_JobPost(job_id) ON DELETE CASCADE
);

CREATE TABLE Tbl_Recruiter (
                               company_id INT NOT NULL,
                               user_id INT NOT NULL,
                               position VARCHAR(100),
                               recruiter_bio TEXT,
                               PRIMAR   Y KEY (company_id, user_id),
                               FOREIGN KEY (user_id) REFERENCES Tbl_user(user_id) ON DELETE CASCADE,
                               FOREIGN KEY (company_id) REFERENCES Tbl_Company(company_id) ON DELETE CASCADE
);

CREATE TABLE Tbl_Message (
                             msg_id SERIAL PRIMARY KEY,
                             company_id INT NOT NULL,
                             user_id INT NOT NULL,
                             content VARCHAR(255),
                             timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             FOREIGN KEY (user_id) REFERENCES Tbl_user(user_id) ON DELETE CASCADE,
                             FOREIGN KEY (company_id) REFERENCES Tbl_Company(company_id) ON DELETE CASCADE
);

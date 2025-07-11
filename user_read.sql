-- read_user_profile
CREATE OR REPLACE FUNCTION get_user_profile(p_user_id INT)
    RETURNS TABLE (
                      full_name VARCHAR,
                      address VARCHAR,
                      email VARCHAR,
                      profile_pic VARCHAR,
                      bio TEXT
                  ) AS $$
BEGIN
    RETURN QUERY
        SELECT
            Tbl_user.full_name,
            Tbl_user.address,
            Tbl_user.email,
            Tbl_user.profile_pic,
            Tbl_user.bio
        FROM Tbl_user
        WHERE Tbl_user.user_id = p_user_id;
END;
$$ LANGUAGE plpgsql;


--get user post
CREATE OR REPLACE FUNCTION get_post(p_post_id INT)
    RETURNS TABLE (
                      full_name VARCHAR,
                      content VARCHAR,
                      media_url VARCHAR,
                      bio TEXT,
                      time_since_posted INTERVAL,
                      visibility visibility_status
                  ) AS $$
BEGIN
    RETURN QUERY
        SELECT
            Tbl_user.full_name,
            Tbl_Post.content,
            Tbl_Post.media_url,
            Tbl_user.bio,
            now() - Tbl_Post.posted_at,  -- ⏱️ interval since post
            Tbl_Post.visibility
        FROM Tbl_Post
                 JOIN Tbl_user ON Tbl_Post.author_id = Tbl_user.user_id
        WHERE Tbl_Post.post_id = p_post_id;
END;
$$ LANGUAGE plpgsql;


-- get user reactions
CREATE OR REPLACE FUNCTION get_reactions(p_post_id INT)
    RETURNS TABLE (
                      reaction_id INT,
                      user_id INT,
                      full_name VARCHAR,
                      reaction_type VARCHAR,
                      reacted_at TIMESTAMP
                  ) AS $$
BEGIN
    RETURN QUERY
        SELECT
            r.reaction_id,
            r.user_id,
            u.full_name,
            r.reaction_type,
            r.reacted_at
        FROM Tbl_Reaction r
                 JOIN Tbl_user u ON r.user_id = u.user_id
        WHERE r.post_id = p_post_id;
END;
$$ LANGUAGE plpgsql;

-- get user comments
CREATE OR REPLACE FUNCTION get_comments(p_post_id INT)
    RETURNS TABLE (
                      comment_id INT,
                      user_id INT,
                      full_name VARCHAR,
                      content VARCHAR,
                      media_url VARCHAR,
                      posted_at TIMESTAMP,
                      visibility BOOLEAN
                  ) AS $$
BEGIN
    RETURN QUERY
        SELECT
            c.comment_id,
            c.user_id,
            u.full_name,
            c.content,
            c.media_url,
            c.posted_at,
            c.visibility
        FROM Tbl_Comment c
                 JOIN Tbl_user u ON c.user_id = u.user_id
        WHERE c.post_id = p_post_id;
END;
$$ LANGUAGE plpgsql;

-- count number of invited send to user
CREATE OR REPLACE FUNCTION count_invites_to_user(p_user_id INT)
    RETURNS INT AS $$
DECLARE
    invite_count INT;
BEGIN
    SELECT COUNT(*) INTO invite_count
    FROM Tbl_Connection
    WHERE user2_id = p_user_id AND status = 'pending';

    RETURN invite_count;
END;
$$ LANGUAGE plpgsql;



-- count number of connections to user
CREATE OR REPLACE FUNCTION count_connection_to_user(p_user_id INT)
    RETURNS INT AS $$
DECLARE
    connection_count INT;
BEGIN
    SELECT COUNT(*) INTO connection_count
    FROM Tbl_Connection
    WHERE user2_id = p_user_id AND status = 'accepted';

    RETURN connection_count;
END;
$$ LANGUAGE plpgsql;


-- count reactions for a post
CREATE OR REPLACE FUNCTION count_reactions(p_post_id INT)
RETURNS INT AS $$
DECLARE
    total_count INT;
BEGIN
    SELECT COUNT(*) INTO total_count
    FROM Tbl_Reaction
    WHERE post_id = p_post_id;

    RETURN total_count;
END;
$$ LANGUAGE plpgsql;


-- count comment in post

CREATE OR REPLACE FUNCTION count_comment(p_post_id INT)
    RETURNS INT AS $$
DECLARE
    total_count INT;
BEGIN
    SELECT COUNT(*) INTO total_count
    FROM Tbl_Comment
    WHERE post_id = p_post_id;

    RETURN total_count;
END;
$$ LANGUAGE plpgsql;


-- Function to get user experience
CREATE OR REPLACE FUNCTION get_user_experience(p_user_id INT)
    RETURNS TABLE (
                      exp_id INT,
                      company_name VARCHAR,
                      title VARCHAR,
                      start_date DATE,
                      end_date DATE,
                      description TEXT
                  ) AS $$
BEGIN
    RETURN QUERY
        SELECT
            Tbl_Experience.exp_id,
            Tbl_Experience.company_name,
            Tbl_Experience.title,
            Tbl_Experience.start_date,
            Tbl_Experience.end_date,
            Tbl_Experience.description
        FROM Tbl_Experience
        WHERE Tbl_Experience.user_id = p_user_id;
END;
$$ LANGUAGE plpgsql;



-- get messages by conversation
CREATE OR REPLACE FUNCTION get_messages_by_conversation(p_conversation_id INT)
    RETURNS TABLE (
                      msg_id INT,
                      sender_id INT,
                      sender_name VARCHAR,
                      content VARCHAR,
                      sent_at TIMESTAMP
                  ) AS $$
BEGIN
    RETURN QUERY
        SELECT
            m.msg_id,
            m.sender_id,
            u.full_name,
            m.content,
            m.timestamp     -- ← this is fine here; just avoid naming output column 'timestamp'
        FROM Tbl_Message m
                 JOIN Tbl_user u ON m.sender_id = u.user_id
        WHERE m.conversation_id = p_conversation_id
        ORDER BY m.timestamp ASC;
END;
$$ LANGUAGE plpgsql;


-- get user skills
CREATE OR REPLACE FUNCTION get_user_skills(p_user_id INT)
    RETURNS TABLE (
                      skill_id INT,
                      skill_name VARCHAR
                  ) AS $$
BEGIN
    RETURN QUERY
        SELECT
            s.skill_id,
            s.skill_name
        FROM Tbl_UserSkill us
                 JOIN Tbl_skill s ON us.skill_id = s.skill_id
        WHERE us.user_id = p_user_id;
END;
$$ LANGUAGE plpgsql;


-- GET user experiences by user_id
CREATE OR REPLACE FUNCTION get_experiences_by_user(p_user_id INT)
    RETURNS TABLE (
                      exp_id INT,
                      company_name VARCHAR,
                      title VARCHAR,
                      start_date DATE,
                      end_date DATE,
                      description TEXT
                  ) AS $$
BEGIN
    RETURN QUERY
        SELECT
            e.exp_id,
            e.company_name,
            e.title,
            e.start_date,
            e.end_date,
            e.description
        FROM Tbl_Experience e
        WHERE e.user_id = p_user_id
        ORDER BY e.start_date DESC;
END;
$$ LANGUAGE plpgsql;


-- Get reposts by user
CREATE OR REPLACE FUNCTION get_reposts_by_user(p_user_id INT)
    RETURNS TABLE (
                      repost_id INT,
                      repost_content TEXT,
                      repost_created_at TIMESTAMP,
                      visibility visibility_status,
                      post_id INT,
                      post_content VARCHAR,
                      post_media_url VARCHAR,
                      post_posted_at TIMESTAMP,
                      original_author_id INT,
                      original_author_name VARCHAR
                  ) AS $$
BEGIN
    RETURN QUERY
        SELECT
            r.repost_is,
            r.content,
            r.created_at,
            r.visibility,
            p.post_id,
            p.content,
            p.media_url,
            p.posted_at,
            u.user_id,
            u.full_name
        FROM Tbl_repost r
                 JOIN Tbl_Post p ON r.post_id = p.post_id
                 JOIN Tbl_user u ON p.author_id = u.user_id
        WHERE r.user_id = p_user_id;
END;
$$ LANGUAGE plpgsql;

create or replace function get_all_user_post(
    _author_id int
)
returns table(
    post_id int,
    author_id int,
    content varchar,
    media_url varchar,
    posted_at timestamp,
    visibility visibility_status
             ) as
$$
BEGIN
    return query
    select
        p.post_id,
        p.author_id,
        p.content,
        p.media_url,
        p.posted_at,
        p.visibility
    from tbl_post p
    where p.author_id = _author_id;
END;
$$ language plpgsql;
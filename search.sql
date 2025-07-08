-- Searching from users, jobs, and posts table -- 
CREATE OR REPLACE FUNCTION search_all(_search VARCHAR)
RETURNS TABLE (
    type TEXT,
    title TEXT
) AS $$
BEGIN
    -- Search in users
    RETURN QUERY
    SELECT
        'user' AS type,
        full_name::TEXT
    FROM tbl_user
    WHERE
        full_name ILIKE _search || '%';

    -- Search in posts
    RETURN QUERY
    SELECT
        'post' AS type,
        (LEFT(content, 10) || '...')::TEXT
    FROM tbl_post
    WHERE
        content ILIKE _search || '%';

    -- Search in job posts
    RETURN QUERY
    SELECT
        'job' AS type,
        j.title::TEXT  -- Disambiguated, no alias used
    FROM tbl_jobpost j
    WHERE
        j.title ILIKE _search || '%' OR
              j.description ILIKE _search || '%';
END;
$$ LANGUAGE plpgsql;
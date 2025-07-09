-- Only available for admin
CREATE OR REPLACE FUNCTION get_all_feed()
RETURNS TABLE (
                    author varchar,
                    content varchar,
                    media_url varchar,
                    posted_at timestamp
                  ) AS $$
BEGIN
    RETURN QUERY
        SELECT
            u.full_name,
            p.content,
            p.media_url,
            p.posted_at
        FROM Tbl_post p
        JOIN tbl_user u on p.author_id = u.user_id;
END;
$$ LANGUAGE plpgsql;
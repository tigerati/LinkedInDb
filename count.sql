CREATE OR REPLACE FUNCTION countReact(
    _post_id INT
)
RETURNS INT AS
$$
DECLARE
    total INT;
BEGIN
    SELECT COUNT(reaction_id) INTO total
    FROM tbl_reaction
    WHERE post_id = _post_id;

    RETURN total;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION countComments(
    _post_id INT
)
RETURNS INT AS
$$
DECLARE
    total INT;
BEGIN
    SELECT COUNT(comment_id) INTO total
    FROM tbl_comment
    WHERE post_id = _post_id;

    RETURN total;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION countRepost(
    _post_id INT
)
RETURNS INT AS
$$
DECLARE
    total INT;
BEGIN
    SELECT COUNT(repost_id) INTO total
    FROM tbl_repost
    WHERE post_id = _post_id;

    RETURN total;
END;
$$ LANGUAGE plpgsql;
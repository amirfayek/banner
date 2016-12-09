-- SGVCHRT
  (SELECT SFBETRM.SFBETRM_PIDM,
          SFBETRM.SFBETRM_TERM_CODE,
          A.SGRCHRT_CHRT_CODE,
          STVCHRT.STVCHRT_DESC
   FROM STVCHRT ,
        SGRCHRT A,
        SFBETRM
   WHERE STVCHRT.STVCHRT_CODE = A.SGRCHRT_CHRT_CODE
     AND A.SGRCHRT_PIDM = SFBETRM.SFBETRM_PIDM
     AND A.SGRCHRT_TERM_CODE_EFF =
       (SELECT MAX(B.SGRCHRT_TERM_CODE_EFF)
        FROM SGRCHRT B
        WHERE B.SGRCHRT_PIDM = A.SGRCHRT_PIDM
          AND B.SGRCHRT_TERM_CODE_EFF <= SFBETRM.SFBETRM_TERM_CODE
          AND B.SGRCHRT_ACTIVE_IND IS NULL)
     AND A.SGRCHRT_ACTIVE_IND IS NULL
   UNION ALL SELECT SFBETRM.SFBETRM_PIDM,
                    SFBETRM.SFBETRM_TERM_CODE,
                    A.SGRCHRT_CHRT_CODE,
                    NULL
   FROM SGRCHRT A,
        SFBETRM
   WHERE A.SGRCHRT_CHRT_CODE IS NULL
     AND A.SGRCHRT_PIDM = SFBETRM.SFBETRM_PIDM
     AND A.SGRCHRT_TERM_CODE_EFF =
       (SELECT MAX(B.SGRCHRT_TERM_CODE_EFF)
        FROM SGRCHRT B
        WHERE B.SGRCHRT_PIDM = A.SGRCHRT_PIDM
          AND B.SGRCHRT_TERM_CODE_EFF <= SFBETRM.SFBETRM_TERM_CODE
          AND B.SGRCHRT_ACTIVE_IND IS NULL)
     AND A.SGRCHRT_ACTIVE_IND IS NULL)
UNION
SELECT SFBETRM.SFBETRM_PIDM,
       SFBETRM.SFBETRM_TERM_CODE,
       '',
       ''
FROM SFBETRM
WHERE NOT EXISTS
    (SELECT 'X'
     FROM SGRCHRT C
     WHERE C.SGRCHRT_PIDM = SFBETRM.SFBETRM_PIDM)
UNION
SELECT SFBETRM.SFBETRM_PIDM,
       SFBETRM.SFBETRM_TERM_CODE,
       '',
       ''
FROM SGRCHRT,
     SFBETRM
WHERE SGRCHRT.SGRCHRT_PIDM = SFBETRM.SFBETRM_PIDM
  AND NOT EXISTS
    (SELECT 'X'
     FROM SGRCHRT D
     WHERE D.SGRCHRT_PIDM = SFBETRM.SFBETRM_PIDM
       AND D.SGRCHRT_TERM_CODE_EFF <= SFBETRM.SFBETRM_TERM_CODE)
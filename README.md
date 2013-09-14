Like most of my READMEs, this is in an FAQ format

# What is this?

It's a replacement Eval database for CSH. It's built to use LDAP as well
as a database backend. LDAP servers as the source of truth for all user
information, and the SQL database supplements it. It uses memcached to
cache LDAP results, since CSH's LDAP is not...fast.

# Why is it in Perl?

Because I know Perl and it's a fine language.

# How do I deploy this?

COMING SOON

(Really it'll just be starman + some middlewares + memcached + db)

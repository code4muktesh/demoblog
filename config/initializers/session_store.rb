# Be sure to restart your server when you modify this file.

#Demoblog::Application.config.session_store :cookie_store, key: '_demoblog_session'
Demoblog::Application.config.cache_store = :redis_store, "redis://localhost:6379/0/cache", { expires_in: 90.minutes }

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Demoblog::Application.config.session_store :active_record_store

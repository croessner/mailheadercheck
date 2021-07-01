-- Echo that the test is starting
mt.echo("*** begin test-20 - one old From:-header format")

-- start the filter
mt.startfilter("./mailheadercheck", "--socket", "inet:40000@127.0.0.1")
mt.sleep(2)

-- try to connect to it
conn = mt.connect("inet:40000@127.0.0.1")
if conn == nil then
     error "mt.connect() failed"
end

-- send envelope macros and sender data
-- mt.helo() is called implicitly
mt.macro(conn, SMFIC_MAIL, "i", "test-id")
if mt.mailfrom(conn, "env_test@example.com") ~= nil then
     error "mt.mailfrom() failed"
end
if mt.getreply(conn) ~= SMFIR_CONTINUE then
     error "mt.mailfrom() unexpected reply"
end

-- send headers
if mt.header(conn, "From", "from_test@example.com (Mail Delivery System)") ~= nil then
     error "mt.header(From) failed"
end
if mt.getreply(conn) ~= SMFIR_CONTINUE then
     error "mt.header(From) unexpected reply"
end
if mt.header(conn, "Subject", "Subject line 1") ~= nil then
     error "mt.header(Subject) failed"
end
if mt.getreply(conn) ~= SMFIR_CONTINUE then
     error "mt.header(Subject) unexpected reply"
end
if mt.header(conn, "Date", "Wed, 23 Jun 2021 16:30:55 +0200") ~= nil then
     error "mt.header(Date) failed"
end
if mt.getreply(conn) ~= SMFIR_CONTINUE then
     error "mt.header(Date) unexpected reply"
end
-- send EOH
if mt.eoh(conn) ~= nil then
     error "mt.eoh() failed"
end
if mt.getreply(conn) ~= SMFIR_ACCEPT then
     error "mt.eoh() unexpected reply"
end

-- wrap it up!
mt.disconnect(conn)

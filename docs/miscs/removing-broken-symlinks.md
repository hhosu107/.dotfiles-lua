https://unix.stackexchange.com/questions/314974/how-to-delete-broken-symlinks-in-one-go

Prerequisites: GNU Findutils

`find . -xtype l -print -delete` (also prints what is being deleted)

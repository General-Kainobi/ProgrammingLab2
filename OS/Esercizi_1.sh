#!/bin/bash

DATABASE="address-book-database.csv"

# Ensure the database file exists
if [ ! -f "$DATABASE" ]; then
    echo "name,surname,phone,mail,city,address" > "$DATABASE"
fi

case $1 in
    view)
        # View the address book sorted by mail
        tail -n +2 "$DATABASE" | sort -t, -k4 | column -s, -t
        ;;
    search)
        # Search for a string in the address book
        if [ -z "$2" ]; then
            echo "Usage: $0 search <string>"
            exit 1
        fi
        IFS=$'\n'
        results=$(grep -i "$2" "$DATABASE" | tail -n +2)
        if [ -z "$results" ]; then
            echo "Not found"
        else
            for entry in $results; do
                IFS=',' read -r name surname phone mail city address <<< "$entry"
                echo "Name: $name"
                echo "Surname: $surname"
                echo "Phone: $phone"
                echo "Mail: $mail"
                echo "City: $city"
                echo "Address: $address"
                echo
            done
        fi
        ;;
    insert)
        # Insert a new entry into the address book
        echo -n "Name: "
        read name
        echo -n "Surname: "
        read surname
        echo -n "Phone: "
        read phone
        echo -n "Mail: "
        read mail
        echo -n "City: "
        read city
        echo -n "Address: "
        read address

        if grep -q -x ".*,$mail,.*" "$DATABASE"; then
            echo "Error: Mail already exists"
        else
            echo "$name,$surname,$phone,$mail,$city,$address" >> "$DATABASE"
            echo "Added"
        fi
        ;;
    delete)
        # Delete an entry by mail
        if [ -z "$2" ]; then
            echo "Usage: $0 delete <mail>"
            exit 1
        fi
        mail=$2
        if grep -q -x ".*,$mail,.*" "$DATABASE"; then
            grep -v -x ".*,$mail,.*" "$DATABASE" > temp && mv temp "$DATABASE"
            echo "Deleted"
        else
            echo "Cannot find any record"
        fi
        ;;
    *)
        echo "Usage: $0 {view|search|insert|delete}"
        exit 1
        ;;
esac

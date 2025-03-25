#!/bin/bash
FILE="address-book-database.csv"
if [ ! -f "$FILE" ]; then
    echo "name,surname,phone,mail,city,address" > "$FILE"
    exit 0
fi
#se il file esiste
#case per selezionare l'opzione
#view visualizza il file ordinato per mail
#search cerca una stringa nel file
#insert inserisce un nuovo record
#delete elimina un record
case $1 in
    view)
        cat $FILE | column -s, -t | head -1 
        tail -n $(wc -l "$FILE") | sort -t, -k4 | column -s, -t # ultimo record del file, saltando l'header in pipe a sort per ordinare per mail e in pipe a column per visualizzare in tabella
        ;;
    search)
        IFS=$'\n'
        risultati=$(grep $2 $FILE)
        if [ -z $risultati ]; then
            echo "Not found"
        fi
        for entry in $risultati; do
            IFS=',' read -r name surname phone mail city address <<< $entry
                echo Name: $name
                echo Surname: $surname
                echo Phone: $phone
                echo Mail: $mail
                echo City: $city
                echo Address: $address
            done
    ;;
    insert)
        echo -n "Name:"
        read name
        echo -n "Surname:"
        read surname
        echo -n "Phone:"
        read phone
        echo -n "Mail:"
        read mail
        echo -n "City:"
        read city
        echo -n "Address:"
        read address
        if grep -q -i $mail $FILE; then
            echo "Error: User already present"
        else
            echo "$name, $surname, $phone, $mail, $city, $address" >> $FILE
            echo "Added"
        fi
    ;;
    delete)
        if grep -q $2 $FILE;then
            if [[ "$2" != "mail" ]]; then
                sed -i $(grep -n $2 $FILE | cut -d: -f1)d $FILE
                echo Deleted
            fi
        else
        echo File Not Found
        fi
esac
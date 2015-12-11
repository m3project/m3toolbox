function deallocSerial(obj)

fclose(obj);

delete(obj);

clear obj;

end
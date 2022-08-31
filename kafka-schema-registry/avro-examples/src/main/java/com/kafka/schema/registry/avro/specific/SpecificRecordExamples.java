package com.kafka.schema.registry.avro.specific;

// add the plugins
// maven clean - remove target folder
// maven package - build target folder
// the file under generated-sources.avro.com.customer didn't work by importing
// so copied the file to this folder

import org.apache.avro.file.DataFileReader;
import org.apache.avro.file.DataFileWriter;
import org.apache.avro.io.DatumReader;
import org.apache.avro.io.DatumWriter;
import org.apache.avro.specific.SpecificDatumReader;
import org.apache.avro.specific.SpecificDatumWriter;

import java.io.File;
import java.io.IOException;

public class SpecificRecordExamples {
    public static void main(String[] args) {
        // step 1: create a specific record
        Customer.Builder customerBuilder = Customer.newBuilder();
        //customerBuilder.setAge("random"); // throw compile errors
        customerBuilder.setAge(16);
        customerBuilder.setFirstName("Mark");
        customerBuilder.setLastName("Simpson");
        customerBuilder.setAutomatedEmail(false); // can be commented out, if it is default
        customerBuilder.setHeight(180f);
        customerBuilder.setWeight(90f);

        Customer customer = customerBuilder.build();
        System.out.println(customer.toString());

        // step 2: write the specific record to a file
        final DatumWriter<Customer> datumWriter = new SpecificDatumWriter<>(Customer.class);

        try (DataFileWriter<Customer> dataFileWriter = new DataFileWriter<>(datumWriter)) {
            dataFileWriter.create(customer.getSchema(), new File("customer-specific.avro"));
            dataFileWriter.append(customer);
            System.out.println("successfully wrote customer-specific.avro");
        } catch (IOException e){
            e.printStackTrace();
        }

        // step 3: read it from a file
        final File file = new File("customer-specific.avro");
        final DatumReader<Customer> datumReader = new SpecificDatumReader<>(Customer.class);
        final DataFileReader<Customer> dataFileReader;
        try {
            System.out.println("Reading our specific record");
            dataFileReader = new DataFileReader<>(file, datumReader);
            while (dataFileReader.hasNext()) {
                Customer readCustomer = dataFileReader.next();
                System.out.println(readCustomer.toString());
                System.out.println("First name: " + readCustomer.getFirstName());
            }
        } catch (IOException e) {
            e.printStackTrace();
        }


        // note, we can read our other customer generated using the generic method!
        // end of the day, no matter the method, Avro is Avro!
        final File fileGeneric = new File("customer-generic.avro");
        final DatumReader<Customer> datumReaderGeneric = new SpecificDatumReader<>(Customer.class);
        final DataFileReader<Customer> dataFileReaderGeneric;
        try {
            System.out.println("Reading our specific record");
            dataFileReaderGeneric = new DataFileReader<>(fileGeneric, datumReaderGeneric);
            while (dataFileReaderGeneric.hasNext()) {
                // interpret data
                Customer readCustomer = dataFileReaderGeneric.next();
                System.out.println(readCustomer.toString());
                System.out.println("Height: " + readCustomer.getHeight());
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

    }
}

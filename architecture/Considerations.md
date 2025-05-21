# Medical Data Review Facility - Considerations

## Introduction

The Dutch Ministry of Health, Welfare and Sport has initiated a program to
provide 'Generic Facilities' that will aid the development of secure and 
privacy friendly medical applications for citizens. 

These Generic Facilities contain authentication services, a pinpointing 
service ('where is my data') and an addressing service ('how can I retrieve 
my data'). 

To be able to demonstrate these generic facilities we have also envisioned 
a 'Medical Data Review Facility' (MDRF), which citizens can use to view the 
medical data that various organizations have on file for them. The MDRF will 
be developed open-source, and modular, so that the software or parts of it 
can be reused by the public and private sectors as building blocks for 
secure and privacy-friendly applications.

Developing Generic Facilities means making lots of choices. While the 
choices we have made will be documented in the Solution Architecture 
document, we also want to provide background on why these choices were made 
and/or which options we have considered before settling on a certain 
solution. This 'considerations' document documents these decisions.

## Architectural considerations

### Client vs Server side processing

When developing an application it is quite common to use a client / server
model where the server deals with business logic and the client is purely 
a user interface. This however has some privacy implications. Typically, 
the server owner / operator will have access to data that is processed on 
the server.

To address any privacy or data processing concerns, for the MDRF we will
choose to process data client-side as much as possible. To avoid the 
common pitfall that different clients process data differently, we will 
encompass the business logic in a suite of 'Software Development Kits' (SDKs) 
that client applications can reuse. By maintaining the business logic in a
single, common component, we achieve a similar level of consistency as 
when the data would be processed by a single server, without the need to 
process data on that server.

### Protocol suite selection

## Other considerations

### Documentation language

We have debated whether project documentation for the MDRF should be in 
Dutch or in English. We have chosen to use English, for the following 
reasons:

* We want to set a bar for privacy and security, that other countries
  may want to follow. It is, therefore, helpful if they can read our
  documentation.
* Even within the Netherlands there is a significant portion of
  engineers that are not Dutch native. On the other hand, all Dutch
  engineers have experience in reading English documentation. By providing
  documentation in English we can provide a more inclusive experience for
  everyone who wants to use (parts of) the project.

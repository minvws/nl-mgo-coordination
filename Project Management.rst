********************************
Project management - MGO
********************************
Versie 1.1 (2024-02-23)
-----------------------

.. contents:: Table of contents
   :depth: 2

.. sectnum::

This document contains the project management for MGO.
This plan is intended to outline the activities and measures that ensure the quality of the software product within the project.
The plan is based on measures from the following standards NEN-ISO/IEC 25010 and `BIO <https://github.com/minvws/nl-rdo-quality-coordination/blob/main/Security/NEN7510_BIO_ISO/BIO%20overview.rst>`_.
If necessary, this plan can be presented to, for example, an auditor or client.

The document addresses three aspects of a project: organization, product, and project.
Under each section, there are various measures that a product owner and/or project lead should take into account.

-----------------------
Organizational measures
-----------------------

.. list-table::
   :header-rows: 1

   * - #
     - Measure
     - Description
     - Reference / action
   * - 1.1
     - The project selects employees based on qualities that a project requires and fits with the iRealisatie quality approach.
     -
        * The job vacancy is created based on specific role and job requirements and selection takes place according to the `policy "Inhuur externen DICIO" <https://github.com/minvws/nl-rdo-quality-coordination/blob/main/Bedrijfsvoering/HR/Inhuur%20externen%20DICIO.md>`_.
     - The project has hired its developers via the specified channels.
   * - 1.2
     - At the start of a project, a security and privacy liaison should be appointed.
     - Contact the relevant support team and document this in the team composition.

        * Contact `privacy@irealisatie.nl` for privacy-related matters
        * Contact `security@irealisatie.nl` for security-related matters
     - The project has been joined by a privacy liason, and a security liaison.
   * - 1.3
     - A team member is appointed to guarantee accessibility of the product
     - A team member (e.g. Product Owner) is appointed to oversee and secure accessibility as one of the key criteria for the software product. Where needed, an accessibility specialist is consulted (for consultation refer to `Accessibility <https://github.com/minvws/nl-rdo-quality-coordination/blob/main/Kwaliteitsmanagement/Procedures/Accessibility.md>`_)
     - The project employs front-end developers as well as an Accessibility specialist.
   * - 1.4
     - The project utilizes tools for defined tasks such as backlog management, task prioritisation, documentation, collaboration and issue management.
     - Ensure that a selection has been made from the supported `toolset <https://github.com/minvws/nl-rdo-quality-coordination/blob/main/Operations/Toolset.md>`_ and document this.
       In case your project deviates from the `toolset <https://github.com/minvws/nl-rdo-quality-coordination/blob/main/Operations/Toolset.md>`_ document your explanation on why the deviation is necessary.
       Use and licences for tools should be aligned with Service Management (irealisatieservicemanagement@minvws.nl). Access to tools is managed by Operations (helpdesk@irealisatie.nl)
     - The project uses https://vws-prd.jira.odc-noord.nl/secure/RapidBoard.jspa?rapidView=190 to maintain a backlog for the development team. Documentation is found on the google drive: https://drive.google.com/drive/folders/18otgdmba-rTH7KhL6dvLyeeotYWvYjB2 and Confluence: https://pgb-prd.confluence.odc-noord.nl/pages/viewpage.action?pageId=164860027. Our toolset: https://github.com/minvws/nl-rdo-mgo-coordination-private/blob/project-management/toolset.md
   * - 1.5
     - Support and activities after go-live: The project has implemented and communicated a mechanism including an Incident Management procedure to support users and to identify potential production issues.
     -
       The project has implemented a mechanism to support users and to identify potential production issues by e.g.:

       1. Identifying improvements and helping users of the services by having a helpdesk. Reports are provided on a regular basis with the most frequently asked questions;
       2. Software improvements and/or issues are suggested via specific contribution groups or channels;
       3. An incident management process is in place to report and resolve potential issues. Refer to ``Incident Management Process (nog in ontwikkeling)``
     - Go-live not yet. 
   * - 1.6
     - Project roles and responsibilities are clearly defined
     -

       * The team has members that oversee and support an agile approach for development, the team members and roles are defined according to `Team verantwoordelijkheden <https://github.com/minvws/nl-rdo-quality-coordination/blob/main/Templates/Team%20verantwoordelijkheden.rst>`_
     - See: https://github.com/minvws/nl-rdo-mgo-coordination-private/blob/project-management/Team%20Verantwoordelijkheden.rst
   * - 1.7
     - The project uses an iterative and incremental development process including a project team and frequent project meetings
     -
       * The development team maintains a roadmap, sprint planning and a product- and sprint backlog.
       * The development team has a fixed meeting frequency including sprint meetings, daily stand-ups, sprint refinement, sprint review, retrospectives, and demos.
     - Project uses a 2-week sprint. Roadmap is discussed by weekly with stakeholders.

----------------
Product measures
----------------

.. list-table::
   :header-rows: 1

   * - #
     - Measure
     - Description
     - Reference / action
   * - 2.1
     - Before development, the Projectlead ensures that the project has a clear definition of the problem and offered solution
     - Include clear description of the problem and the offered solution. This description could be included in e.g. a Project Charter and/or Offerte. Also refer to `Offerteproces <https://github.com/minvws/nl-rdo-quality-coordination/blob/main/iAlgemeen/Procedures/Offerteproces.rst>`_

       * Business requirements: Target group and problem description, Objective, Desired result, Description of (technical) solution;
       * Technical requirements: Functional requirements, Non-functional requirements, (minimum) privacy requirements, (minimum) security requirements;
       * Description of the solution
       * Privacy impact assessment
       * Business impact analysis
         Also refer to Template offerte (and offerte examples): ``O:\DICIO\1. Clusters\1.5 iRealisatie\38. Offertes (nieuwe) projecten``

         .. Also refer to `Annex A8.27 <https://github.com/minvws/nl-rdo-quality-coordination/blob/main/Security/NEN7510_BIO_ISO/Annex%20A%20-%20Beheersmaatregelen/A.08%20Technologische%20beheersmaatregelen/A.8.27%20Veilige%20systeemarchitectuur%20en%20technischeuitgangspunten.rst>`_

     - See: https://drive.google.com/drive/folders/18otgdmba-rTH7KhL6dvLyeeotYWvYjB2, https://vws-prd.jira.odc-noord.nl/secure/RapidBoard.jspa?rapidView=190&dagstart, TODO: offertes documentatie locatie.
   * - 2.2.1
     - Project structure to ensure a reliable (first) solution: Define Definition of Ready
     - Define the "Definition of Ready" which contains a set of criteria that the product must meet (develop Feature Flags if applicable)

         * Refer to template `Definition of Ready <https://github.com/minvws/nl-rdo-quality-coordination/blob/main/Templates/Definition%20of%20Ready.rst>`_
     - TODO: Scrummaster refinement info
   * - 2.2.2
     - Project structure to ensure a reliable (first) solution: DTAP environment
     - Set up an adequate Development-Test-Acceptance-Production (DTAP) environment including the necessary segregation of duties (min. 4-eyes principle).

        .. Also refer to `Annex A.8.31 <https://github.com/minvws/nl-rdo-quality-coordination/blob/main/Security/NEN7510_BIO_ISO/Annex%20A%20-%20Beheersmaatregelen/A.08%20Technologische%20beheersmaatregelen/A.8.31%20Scheiding%20van%20ontwikkel-%2C%20test-%20en%20productieomgevingen.rst>`_

     - Not yet in place.
   * - 2.2.3
     - Project structure to ensure a reliable (first) solution: The development process includes a quality pipeline including relevant workflows and quality gates
     - The development process includes a quality pipeline including relevant workflows and quality gates based on the ``iRealisatie Quality Pipeline (nog in ontwikkeling)`` This pipeline include the at a minimum the following steps:

       * Construction of the software,
       * Unit tests, Regression tests,
       * Security tests,
       * Performance tests,
       * Accessibility tests,
       * Source code quality checks,
       * Build of the software,
     - Pipeline has been constructed and maintained for this purpose.
   * - 2.3
     - Apply a "Release checklist" that is completed with each release.
     - Apply a "Release checklist" that is completed with each release and communicate with Operations as a pre-requisite for deployment. The Release Checklist includes:

       1. Privacy Statement,
       2. Security Statement,
       3. Operations Statement
       4. Internal release notes;

         * Refer to template `Release Checklist <https://github.com/minvws/nl-rdo-quality-coordination/blob/main/Templates/Release%20Checklist.rst>`_
     - TODO: check with dev team
   * - 2.4
     - Define, document and apply a strategy for Open-source.
     - Define, document and apply a strategy for Open-source. The description explains the chosen strategy and reasoning behind. Refer to ``Open-source policy`` (nog in ontwikkeling) for the additional explanation. For each opensource deployment, the `Open-source checklist <https://github.com/minvws/nl-rdo-quality-coordination/blob/main/Templates/Open-source%20checklist.md>`_ should be completed
     - [Link]
   * - 2.5
     - Apply the iRealisatie `Privacy by design framework <https://github.com/minvws/nl-rdo-quality-coordination/blob/main/Privacy/Privacy%20by%20Design%20Framework.md>`_ for your project and adhere to the `Privacy requirements <https://github.com/minvws/nl-rdo-quality-coordination/blob/main/Privacy/Privacy%20requirements.md>`_
     - Ensure compliance with the `Privacy by design framework <https://github.com/minvws/nl-rdo-quality-coordination/blob/main/Privacy/Privacy%20by%20Design%20Framework.md>`_ for your project and adhere to the `Privacy requirements <https://github.com/minvws/nl-rdo-quality-coordination/blob/main/Privacy/Privacy%20requirements.md>`_. Align with your Privacy liason on a regular basis.

        .. Also refer to `Annex A.8.28 Veilig coderen <https://github.com/minvws/nl-rdo-quality-coordination/blob/main/Security/NEN7510_BIO_ISO/Annex%20A%20-%20Beheersmaatregelen/A.08%20Technologische%20beheersmaatregelen/A.8.28%20Veilig%20coderen.rst>`_

     - Privacy liason is responsible for making sure we adhere to the standards. Team is actively involved in this proces.
   * - 2.6
     - Security of the developed product are periodically assessed
     - Before the first go-live, a security assessment is performed including `FMEA richtlijn <https://github.com/minvws/nl-rdo-quality-coordination/blob/main/Security/Proces%20FMEA%20risicomanagement%20iRealisatie.rst>`_. Additional Security assessments are applied when needed according to the `Information Security Policy <https://github.com/minvws/nl-rdo-quality-coordination/blob/main/Security/Informatiebeveiligingsbeleid%20iRealisatie%202024-2026.rst>`_ and `Pentest Policy <https://github.com/minvws/nl-rdo-quality-coordination/blob/main/Security/Beleid%20Pentesten.rst>`_. Depending on the Release, FMEA results, type of solution, type of data and the users, the level of privacy- and security involvement and assessments may vary.

         .. `Annex A.8.29 <https://github.com/minvws/nl-rdo-quality-coordination/blob/main/Security/NEN7510_BIO_ISO/Annex%20A%20-%20Beheersmaatregelen/A.08%20Technologische%20beheersmaatregelen/A.8.29%20Testen%20van%20de%20beveiliging%20tijdens%20ontwikkeling%20en%20acceptatie.rst>`_

     - Security liason is responsible for making sure we adhere to the standards. Team is actively involved in this proces.
   * - 2.7
     - The project aligns defined products and information with the relevant stakeholders in each phase
     - Visualizations and/or prototypes of the desired solution are documented and communicated to the relevant stakeholders. These visualisations and prototypes might include: processflows, (clickable) design demo's and architecture designs.
     - This agile team provides live demonstrations, in some cases FIGMA demo's to ensure correct translation of stakeholders wishes an demands.
   * - 2.8
     - The project ensures correct functioning and availability of the product with automated regressiontests
     - Automated regression tests are included in the Definition of Done and are performed to verify whether previously developed software works correctly after changes to the software or connection to other external interfaces through automated regression tests.
     - Automated regression tests in place - each sprint these are added to, and are run at least once every release.
   * - 2.9
     - Regular testing of users/User panels
     - By frequently applying usertests on the (concept) product, iRealisatie continues to develop products that meets user requirements. All digital solutions or services that are built take into account accessibility. Tools might be used to conduct e.g. customer satisfaction survey (refer to `Instructie tevredenheidsonderzoek <../../../Kwaliteitsmanagement/Tooling/Customer%20satisfaction%20survey.md>`_).
     -  (potential reference to accessibility statement) Not yet in place.
   * - 2.10
     - The project determines technical debt and resolves it systematically.
     - The project determines technical debt and resolves it systematically (incl. prioritisation). Tools such as CheckMarx and SIG are applied.
     - Team takes care of this on regular basis. Scrummaster encourages this behaviour.

----------------
Process measures
----------------

.. list-table::
   :header-rows: 1

   * - #
     - Measure
     - Description
     - Reference / action
   * - 3.1
     - Apply an automated continuous integration (CI) pipeline that demonstrably works correctly and builds the software, installs it in test environment and tests for functional and non-functional properties.
     - An automated continuous integration pipeline is applied according to the iRealisatie best practise, refer to ``architecture for our CI/CD setup (nog in ontwikkeling)``
     - Automated pipeline is in use.
   * - 3.2
     - The project identifies, mitigates and monitors risks
     - Continuous monitoring:

        1. The Security Operations Center monitors specific use cases that have been predefined in collaboration with PO and are security related.
        2. The Z-CERT team (part of SOC) follows up the incidents with research and analysis.
        3. The monitoring dashboard or logging events can be consulted 24/7 from Calvin
        4. Logging event overview: Monitoring the use of the applications so that it can be identified how people are using the services and any improvement actions can be initiated and action can be taken in the event of incidents.

        .. Also refer to `Annex 8.16 Monitoren van activeiten <https://github.com/minvws/nl-rdo-quality-coordination/blob/main/Security/NEN7510_BIO_ISO/Annex%20A%20-%20Beheersmaatregelen/A.08%20Technologische%20beheersmaatregelen/A.8.16%20Monitoren%20van%20activeiten.rst>`_

     - TODO: check met architect/dev team
   * - 3.3
     - Deployment
     - During the deployment process, the following documents are documented, established and published where necessary:

       1. Deployment- / rolloutplan;
       2. Notary / escrow stamp (if needed);
       3. Public release notes;
       4. Logging NEN / SSD
       5. Up-to-date software/libraries/components (incl. AS built documentation and Reusability check)
     - [Link]
   * - 3.4
     - The project ensures that the product continuously meets the "Definition of Done"
     - Products meet the quality standards established by the project. Meeting the quality standards is part of the Definition of Done and addressing any deviations is carried out in a systematic manner.
        - Definition of Done
            Within the MGO team we develop the MGO application that is being consisted of the Backend services, the Web application and the iOS & Android native applications.
            Thus, a task has a different definition of Done, depending on whether it comes from the BE, FE or the app development.

            - App development
                - from the concept/idea > Refinement (Acceptance Criteria defined) > Todo > In progress > Review (AC are met) > Release > QA (AC are met) > Done
            - Web development
                - from the concept/idea > Refinement (Acceptance Criteria defined) > Todo > In progress > Review (AC are met) > merge to develop > QA (AC are met - critical issues are resolved on a new branch) > Waiting for release > Release release/vx.x.x (deployment to Test env) > merge to main (deployment to Acc) > Done
            - Backend development
                - from the concept/idea > Refinement (Acceptance Criteria defined) > Todo > In progress > Review (AC are met) > merge to develop > QA (AC are met - critical issues are resolved on a new branch) > Waiting for release > Release release/vx.x.x (deployment to Test env) > merge to main (deployment to Acc) > Done
        - The DoD can also be found on NextCloud, under MGO/01 Project/02 Team: https://nextcloud.irealisatie.nl/apps/files/files/575008?dir=/MGO/01%20Project/02%20Team&openfile=true
     - [Action]
   * - 3.5
     - The project reviews adherence to the defined Quality Pipeline (refer to 2.2.3) on a periodic basis.
     - To ensures consistent adherence to the defined Quality Pipeline (refer to 2.2.3) by performing a monitoring on a continuous or periodic basis. Resulting quality reports are discussed with the projectteam. If needed, the Quality Pipeline and quality standards are revised.
     - [Link]
   * - 3.6
     - The project is aligned with iRealisatie Kwaliteitsmanagement and therefore falls under iRealisatie's Quality Assurance approach.
     - The project lead ensures that the project is in scope for Kwaliteitsmanagement. Kwaliteitsmanagement ensures that quality criteria for the various projects are clearly communicated. Also, quality criteria are periodically tested through assessments and audits.

        .. Also refer to `Annex A5.35 <https://github.com/minvws/nl-rdo-quality-coordination/blob/main/Security/NEN7510_BIO_ISO/Annex%20A%20-%20Beheersmaatregelen/A.05%20Organisatorische%20beheersmaatregelen/A.5.35%20Onafhankelijke%20beoordeling%20van%20informatiebeveiliging.rst>`_

     - [Action]
   * - 3.7
     - Apply complete and correct information management
     - The project ensures that the product meets requirements in a traceable manner. `Beleid Informatiehuishouding <https://github.com/minvws/nl-rdo-quality-coordination/blob/main/iAlgemeen/Procedures/Beleid%20Informatiehuishouding.rst>`_ contains the requirements for securing any relevant data from the product applications and/or collaborative tools.
     - [Action]
   * - 3.8
     - [If applicable] The project TVS (toegangverleningservice e.g. DigiD/eHerkenning) interfaces are compliant to ``Normenkader 3.0 voor ICT-beveiligingsassessments``
     - The project is compliant to
        * `Normenkader 3.0 voor ICT-beveiligingsassessments <https://www.logius.nl/domeinen/toegang/digid/ict-beveiligingsassessments-digid/documentatie/norm-ict-beveiligingsassessments-digid>`_. Relevant evidence and documentation is continuously maintained in order to provide an external auditor with documentation and evidence during the periodic ``ICT-beveiligingsassessments DigiD``. 
        * Version 2.0 of the TVS Testing Checklist. This document contains the test criteria that DICTU sets for the connection of an ICT Software supplier or an individual service provider to the TVS routing facility. `Checklist Testen TVS 2.0 <https://www.dictu.nl/toegangverleningservice/documentatie-en-links/checklist-testen-tvs-2>`_
     - [Link]


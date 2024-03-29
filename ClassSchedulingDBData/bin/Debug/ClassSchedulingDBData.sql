﻿/*
Deployment script for ClassSchedulingDBData

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "ClassSchedulingDBData"
:setvar DefaultFilePrefix "ClassSchedulingDBData"
:setvar DefaultDataPath "C:\Users\David Nguyen\AppData\Local\Microsoft\VisualStudio\SSDT\ClassSchedulingDBData"
:setvar DefaultLogPath "C:\Users\David Nguyen\AppData\Local\Microsoft\VisualStudio\SSDT\ClassSchedulingDBData"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
/*
The column [dbo].[apiEvents].[deliveryType] is being dropped, data loss could occur.

The column [dbo].[apiEvents].[recurring] is being dropped, data loss could occur.

The column [dbo].[apiEvents].[sessionID] is being dropped, data loss could occur.

The column [dbo].[apiEvents].[classQuarterNumber] on table [dbo].[apiEvents] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

The column [dbo].[apiEvents].[quarter] on table [dbo].[apiEvents] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.

The column [dbo].[apiEvents].[year] on table [dbo].[apiEvents] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
*/

IF EXISTS (select top 1 1 from [dbo].[apiEvents])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
/*
The column [dbo].[UserInformation].[eventsAuthorID] on table [dbo].[UserInformation] must be added, but the column has no default value and does not allow NULL values. If the table contains data, the ALTER script will not work. To avoid this issue you must either: add a default value to the column, mark it as allowing NULL values, or enable the generation of smart-defaults as a deployment option.
*/

IF EXISTS (select top 1 1 from [dbo].[UserInformation])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
PRINT N'Dropping Foreign Key [dbo].[EventSession]...';


GO
ALTER TABLE [dbo].[apiEvents] DROP CONSTRAINT [EventSession];


GO
PRINT N'Dropping Foreign Key [dbo].[eventAuthorReference]...';


GO
ALTER TABLE [dbo].[apiEvents] DROP CONSTRAINT [eventAuthorReference];


GO
PRINT N'Dropping Foreign Key [dbo].[eventInstitutionReference]...';


GO
ALTER TABLE [dbo].[apiEvents] DROP CONSTRAINT [eventInstitutionReference];


GO
PRINT N'Dropping Foreign Key [dbo].[referenceToInstitution]...';


GO
ALTER TABLE [dbo].[UserInformation] DROP CONSTRAINT [referenceToInstitution];


GO
PRINT N'Dropping Foreign Key [dbo].[referenceToRealUser]...';


GO
ALTER TABLE [dbo].[SessionTokens] DROP CONSTRAINT [referenceToRealUser];


GO
PRINT N'Dropping Foreign Key [dbo].[DepartmentInstitutionReference]...';


GO
ALTER TABLE [dbo].[Departments] DROP CONSTRAINT [DepartmentInstitutionReference];


GO
PRINT N'Starting rebuilding table [dbo].[apiEvents]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_apiEvents] (
    [Id]                 INT           IDENTITY (1, 1) NOT NULL,
    [eventData]          VARCHAR (MAX) NOT NULL,
    [eventUUID]          VARCHAR (256) NOT NULL,
    [eventAuthorHash]    VARCHAR (512) NOT NULL,
    [InstructorHash]     VARCHAR (64)  NULL,
    [institutonID]       VARCHAR (64)  NOT NULL,
    [classQuarterNumber] INT           NOT NULL,
    [year]               INT           NOT NULL,
    [quarter]            INT           NOT NULL,
    [building]           VARCHAR (64)  NOT NULL,
    [room]               VARCHAR (64)  NOT NULL,
    [coursePrefix]       VARCHAR (24)  NULL,
    [courseNumber]       VARCHAR (12)  NULL,
    [Section]            VARCHAR (12)  NULL,
    [Component]          VARCHAR (64)  NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([eventUUID] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[apiEvents])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_apiEvents] ON;
        INSERT INTO [dbo].[tmp_ms_xx_apiEvents] ([Id], [eventData], [eventUUID], [eventAuthorHash], [institutonID], [building], [room], [coursePrefix], [courseNumber], [Section], [Component])
        SELECT   [Id],
                 [eventData],
                 [eventUUID],
                 [eventAuthorHash],
                 [institutonID],
                 [building],
                 [room],
                 [coursePrefix],
                 [courseNumber],
                 [Section],
                 [Component]
        FROM     [dbo].[apiEvents]
        ORDER BY [Id] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_apiEvents] OFF;
    END

DROP TABLE [dbo].[apiEvents];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_apiEvents]', N'apiEvents';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Altering Table [dbo].[Departments]...';


GO
ALTER TABLE [dbo].[Departments] ALTER COLUMN [departmentName] VARCHAR (64) NOT NULL;

ALTER TABLE [dbo].[Departments] ALTER COLUMN [departmentType] VARCHAR (12) NOT NULL;


GO
PRINT N'Starting rebuilding table [dbo].[UserInformation]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_UserInformation] (
    [Id]                   INT           IDENTITY (1, 1) NOT NULL,
    [accountHash]          VARCHAR (512) NOT NULL,
    [eventsAuthorID]       VARCHAR (512) NOT NULL,
    [firstName]            VARCHAR (64)  NOT NULL,
    [lastName]             VARCHAR (64)  NOT NULL,
    [primaryEmail]         VARCHAR (64)  NOT NULL,
    [primaryInstitutionID] VARCHAR (64)  NOT NULL,
    [accountFlag]          INT           NOT NULL,
    [departmentID]         INT           NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([accountHash] ASC),
    UNIQUE NONCLUSTERED ([eventsAuthorID] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[UserInformation])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_UserInformation] ON;
        INSERT INTO [dbo].[tmp_ms_xx_UserInformation] ([Id], [accountHash], [firstName], [lastName], [primaryEmail], [primaryInstitutionID], [accountFlag])
        SELECT   [Id],
                 [accountHash],
                 [firstName],
                 [lastName],
                 [primaryEmail],
                 [primaryInstitutionID],
                 [accountFlag]
        FROM     [dbo].[UserInformation]
        ORDER BY [Id] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_UserInformation] OFF;
    END

DROP TABLE [dbo].[UserInformation];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_UserInformation]', N'UserInformation';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating Table [dbo].[CourseOfferings]...';


GO
CREATE TABLE [dbo].[CourseOfferings] (
    [Id]              INT IDENTITY (1, 1) NOT NULL,
    [courseOfferedID] INT NOT NULL,
    [ClassNumber]     INT NULL,
    [quarter]         INT NULL,
    [year]            INT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([ClassNumber] ASC)
);


GO
PRINT N'Creating Table [dbo].[CourseOfferingsTemplates]...';


GO
CREATE TABLE [dbo].[CourseOfferingsTemplates] (
    [Id]            INT           IDENTITY (1, 1) NOT NULL,
    [ProgramID]     INT           NOT NULL,
    [InstitutionID] VARCHAR (64)  NOT NULL,
    [Title]         VARCHAR (128) NOT NULL,
    [CoursePrefix]  VARCHAR (24)  NOT NULL,
    [CourseNumber]  VARCHAR (24)  NOT NULL,
    [Component]     VARCHAR (64)  NOT NULL,
    [quarterNumber] INT           NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UniqueCourseOffering] UNIQUE NONCLUSTERED ([InstitutionID] ASC, [CoursePrefix] ASC, [CourseNumber] ASC, [quarterNumber] ASC, [Component] ASC)
);


GO
PRINT N'Creating Table [dbo].[ProgramOfferings]...';


GO
CREATE TABLE [dbo].[ProgramOfferings] (
    [Id]                     INT           IDENTITY (1, 1) NOT NULL,
    [InstitutionID]          VARCHAR (64)  NOT NULL,
    [AssociatedDepartmentID] INT           NOT NULL,
    [ProgramName]            VARCHAR (256) NOT NULL,
    [ProgramType]            VARCHAR (12)  NOT NULL,
    [ProgramVersion]         INT           NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UniqueProgramOffering] UNIQUE NONCLUSTERED ([InstitutionID] ASC, [ProgramType] ASC, [ProgramName] ASC, [ProgramVersion] ASC)
);


GO
PRINT N'Creating Table [dbo].[ValidPrefixes]...';


GO
CREATE TABLE [dbo].[ValidPrefixes] (
    [Id]           INT          IDENTITY (1, 1) NOT NULL,
    [Prefix]       VARCHAR (12) NOT NULL,
    [departmentID] INT          NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([Prefix] ASC),
    CONSTRAINT [uniqueDepartmentPrefix] UNIQUE NONCLUSTERED ([Prefix] ASC, [departmentID] ASC)
);


GO
PRINT N'Creating Foreign Key [dbo].[eventAuthorReference]...';


GO
ALTER TABLE [dbo].[apiEvents] WITH NOCHECK
    ADD CONSTRAINT [eventAuthorReference] FOREIGN KEY ([eventAuthorHash]) REFERENCES [dbo].[UserInformation] ([accountHash]);


GO
PRINT N'Creating Foreign Key [dbo].[eventInstitutionReference]...';


GO
ALTER TABLE [dbo].[apiEvents] WITH NOCHECK
    ADD CONSTRAINT [eventInstitutionReference] FOREIGN KEY ([institutonID]) REFERENCES [dbo].[InstitutionsRegistry] ([InstitutionID]);


GO
PRINT N'Creating Foreign Key [dbo].[referenceToRealUser]...';


GO
ALTER TABLE [dbo].[SessionTokens] WITH NOCHECK
    ADD CONSTRAINT [referenceToRealUser] FOREIGN KEY ([accountHash]) REFERENCES [dbo].[UserInformation] ([accountHash]);


GO
PRINT N'Creating Foreign Key [dbo].[userAssociatedInstitution]...';


GO
ALTER TABLE [dbo].[UserInformation] WITH NOCHECK
    ADD CONSTRAINT [userAssociatedInstitution] FOREIGN KEY ([primaryInstitutionID]) REFERENCES [dbo].[InstitutionsRegistry] ([InstitutionID]);


GO
PRINT N'Creating Foreign Key [dbo].[UserAssociatedDepartment]...';


GO
ALTER TABLE [dbo].[UserInformation] WITH NOCHECK
    ADD CONSTRAINT [UserAssociatedDepartment] FOREIGN KEY ([departmentID]) REFERENCES [dbo].[Departments] ([departmentID]);


GO
PRINT N'Creating Foreign Key [dbo].[CourseOfferedTemplate]...';


GO
ALTER TABLE [dbo].[CourseOfferings] WITH NOCHECK
    ADD CONSTRAINT [CourseOfferedTemplate] FOREIGN KEY ([courseOfferedID]) REFERENCES [dbo].[CourseOfferingsTemplates] ([Id]);


GO
PRINT N'Creating Foreign Key [dbo].[InstitutionCourseOfferings]...';


GO
ALTER TABLE [dbo].[CourseOfferingsTemplates] WITH NOCHECK
    ADD CONSTRAINT [InstitutionCourseOfferings] FOREIGN KEY ([InstitutionID]) REFERENCES [dbo].[InstitutionsRegistry] ([InstitutionID]);


GO
PRINT N'Creating Foreign Key [dbo].[CourseProgramReference]...';


GO
ALTER TABLE [dbo].[CourseOfferingsTemplates] WITH NOCHECK
    ADD CONSTRAINT [CourseProgramReference] FOREIGN KEY ([ProgramID]) REFERENCES [dbo].[ProgramOfferings] ([Id]);


GO
PRINT N'Creating Foreign Key [dbo].[InstitutionProgramOfferings]...';


GO
ALTER TABLE [dbo].[ProgramOfferings] WITH NOCHECK
    ADD CONSTRAINT [InstitutionProgramOfferings] FOREIGN KEY ([InstitutionID]) REFERENCES [dbo].[InstitutionsRegistry] ([InstitutionID]);


GO
PRINT N'Creating Foreign Key [dbo].[ProgramsDepartment]...';


GO
ALTER TABLE [dbo].[ProgramOfferings] WITH NOCHECK
    ADD CONSTRAINT [ProgramsDepartment] FOREIGN KEY ([AssociatedDepartmentID]) REFERENCES [dbo].[Departments] ([departmentID]);


GO
PRINT N'Creating Foreign Key [dbo].[DepartmentCoursePrefixes]...';


GO
ALTER TABLE [dbo].[ValidPrefixes] WITH NOCHECK
    ADD CONSTRAINT [DepartmentCoursePrefixes] FOREIGN KEY ([departmentID]) REFERENCES [dbo].[Departments] ([departmentID]);


GO
PRINT N'Creating Foreign Key [dbo].[InstitutionDepartments]...';


GO
ALTER TABLE [dbo].[Departments] WITH NOCHECK
    ADD CONSTRAINT [InstitutionDepartments] FOREIGN KEY ([institutionID]) REFERENCES [dbo].[InstitutionsRegistry] ([InstitutionID]);


GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[apiEvents] WITH CHECK CHECK CONSTRAINT [eventAuthorReference];

ALTER TABLE [dbo].[apiEvents] WITH CHECK CHECK CONSTRAINT [eventInstitutionReference];

ALTER TABLE [dbo].[SessionTokens] WITH CHECK CHECK CONSTRAINT [referenceToRealUser];

ALTER TABLE [dbo].[UserInformation] WITH CHECK CHECK CONSTRAINT [userAssociatedInstitution];

ALTER TABLE [dbo].[UserInformation] WITH CHECK CHECK CONSTRAINT [UserAssociatedDepartment];

ALTER TABLE [dbo].[CourseOfferings] WITH CHECK CHECK CONSTRAINT [CourseOfferedTemplate];

ALTER TABLE [dbo].[CourseOfferingsTemplates] WITH CHECK CHECK CONSTRAINT [InstitutionCourseOfferings];

ALTER TABLE [dbo].[CourseOfferingsTemplates] WITH CHECK CHECK CONSTRAINT [CourseProgramReference];

ALTER TABLE [dbo].[ProgramOfferings] WITH CHECK CHECK CONSTRAINT [InstitutionProgramOfferings];

ALTER TABLE [dbo].[ProgramOfferings] WITH CHECK CHECK CONSTRAINT [ProgramsDepartment];

ALTER TABLE [dbo].[ValidPrefixes] WITH CHECK CHECK CONSTRAINT [DepartmentCoursePrefixes];

ALTER TABLE [dbo].[Departments] WITH CHECK CHECK CONSTRAINT [InstitutionDepartments];


GO
PRINT N'Update complete.';


GO

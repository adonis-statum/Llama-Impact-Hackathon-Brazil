-- CreateTable
CREATE TABLE "Vaga" (
    "id" TEXT NOT NULL,
    "jobTitle" TEXT NOT NULL,
    "companyId" TEXT NOT NULL,
    "jobDescription" TEXT NOT NULL,
    "employmentType" TEXT NOT NULL,
    "experienceLevel" TEXT NOT NULL,
    "salaryRangeId" TEXT NOT NULL,
    "responsibilities" TEXT[],
    "requirementId" TEXT NOT NULL,
    "benefits" TEXT[],
    "postedDate" TEXT NOT NULL,
    "closingDate" TEXT NOT NULL,

    CONSTRAINT "Vaga_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Curriculo" (
    "id" TEXT NOT NULL,
    "personalInformationId" TEXT NOT NULL,
    "summary" TEXT NOT NULL,
    "skills" TEXT[],

    CONSTRAINT "Curriculo_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VagaCurriculo" (
    "id" TEXT NOT NULL,
    "vagaId" TEXT NOT NULL,
    "curriculoId" TEXT NOT NULL,

    CONSTRAINT "VagaCurriculo_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Company" (
    "id" TEXT NOT NULL,
    "locationId" TEXT NOT NULL,
    "website" TEXT NOT NULL,
    "description" TEXT NOT NULL,

    CONSTRAINT "Company_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Location" (
    "id" TEXT NOT NULL,
    "street" TEXT NOT NULL,
    "city" TEXT NOT NULL,
    "state" TEXT NOT NULL,
    "zipCode" TEXT NOT NULL,
    "country" TEXT NOT NULL,

    CONSTRAINT "Location_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SalaryRange" (
    "id" TEXT NOT NULL,
    "min" TEXT NOT NULL,
    "max" TEXT NOT NULL,
    "currency" TEXT NOT NULL,
    "frequency" TEXT NOT NULL,

    CONSTRAINT "SalaryRange_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Requirement" (
    "id" TEXT NOT NULL,
    "minimumEducation" TEXT NOT NULL,
    "experienceYears" TEXT NOT NULL,
    "skills" TEXT[],
    "skillsId" TEXT NOT NULL,

    CONSTRAINT "Requirement_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Language" (
    "id" TEXT NOT NULL,
    "language" TEXT NOT NULL,
    "proficiency" TEXT NOT NULL,
    "curriculoId" TEXT NOT NULL,

    CONSTRAINT "Language_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LanguagesOnRequirements" (
    "languageId" TEXT NOT NULL,
    "requirementId" TEXT NOT NULL,

    CONSTRAINT "LanguagesOnRequirements_pkey" PRIMARY KEY ("requirementId","languageId")
);

-- CreateTable
CREATE TABLE "PersonalInformation" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "locationId" TEXT NOT NULL,

    CONSTRAINT "PersonalInformation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Experience" (
    "id" TEXT NOT NULL,
    "jobTitle" TEXT NOT NULL,
    "company" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    "startDate" TEXT NOT NULL,
    "endDate" TEXT NOT NULL,
    "responsibilities" TEXT[],
    "curriculoId" TEXT NOT NULL,

    CONSTRAINT "Experience_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Education" (
    "id" TEXT NOT NULL,
    "degree" TEXT NOT NULL,
    "institution" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    "startDate" TEXT NOT NULL,
    "endDate" TEXT NOT NULL,
    "curriculoId" TEXT NOT NULL,

    CONSTRAINT "Education_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Reference" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "relationship" TEXT NOT NULL,
    "company" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "curriculoId" TEXT NOT NULL,

    CONSTRAINT "Reference_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_VagaCurriculo" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_VagaCurriculo_AB_unique" ON "_VagaCurriculo"("A", "B");

-- CreateIndex
CREATE INDEX "_VagaCurriculo_B_index" ON "_VagaCurriculo"("B");

-- AddForeignKey
ALTER TABLE "Vaga" ADD CONSTRAINT "Vaga_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Vaga" ADD CONSTRAINT "Vaga_salaryRangeId_fkey" FOREIGN KEY ("salaryRangeId") REFERENCES "SalaryRange"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Vaga" ADD CONSTRAINT "Vaga_requirementId_fkey" FOREIGN KEY ("requirementId") REFERENCES "Requirement"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Curriculo" ADD CONSTRAINT "Curriculo_personalInformationId_fkey" FOREIGN KEY ("personalInformationId") REFERENCES "PersonalInformation"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VagaCurriculo" ADD CONSTRAINT "VagaCurriculo_vagaId_fkey" FOREIGN KEY ("vagaId") REFERENCES "Vaga"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VagaCurriculo" ADD CONSTRAINT "VagaCurriculo_curriculoId_fkey" FOREIGN KEY ("curriculoId") REFERENCES "Curriculo"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Company" ADD CONSTRAINT "Company_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "Location"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Language" ADD CONSTRAINT "Language_curriculoId_fkey" FOREIGN KEY ("curriculoId") REFERENCES "Curriculo"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LanguagesOnRequirements" ADD CONSTRAINT "LanguagesOnRequirements_languageId_fkey" FOREIGN KEY ("languageId") REFERENCES "Language"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LanguagesOnRequirements" ADD CONSTRAINT "LanguagesOnRequirements_requirementId_fkey" FOREIGN KEY ("requirementId") REFERENCES "Requirement"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PersonalInformation" ADD CONSTRAINT "PersonalInformation_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "Location"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Experience" ADD CONSTRAINT "Experience_curriculoId_fkey" FOREIGN KEY ("curriculoId") REFERENCES "Curriculo"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Education" ADD CONSTRAINT "Education_curriculoId_fkey" FOREIGN KEY ("curriculoId") REFERENCES "Curriculo"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reference" ADD CONSTRAINT "Reference_curriculoId_fkey" FOREIGN KEY ("curriculoId") REFERENCES "Curriculo"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_VagaCurriculo" ADD CONSTRAINT "_VagaCurriculo_A_fkey" FOREIGN KEY ("A") REFERENCES "Curriculo"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_VagaCurriculo" ADD CONSTRAINT "_VagaCurriculo_B_fkey" FOREIGN KEY ("B") REFERENCES "Vaga"("id") ON DELETE CASCADE ON UPDATE CASCADE;

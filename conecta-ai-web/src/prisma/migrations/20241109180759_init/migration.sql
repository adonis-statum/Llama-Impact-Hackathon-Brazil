-- CreateTable
CREATE TABLE "Vaga" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "nome" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "Curriculo" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "nome" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "VagaCurriculo" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "vagaId" TEXT NOT NULL,
    "curriculoId" TEXT NOT NULL,
    CONSTRAINT "VagaCurriculo_vagaId_fkey" FOREIGN KEY ("vagaId") REFERENCES "Vaga" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "VagaCurriculo_curriculoId_fkey" FOREIGN KEY ("curriculoId") REFERENCES "Curriculo" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "_VagaCurriculo" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,
    CONSTRAINT "_VagaCurriculo_A_fkey" FOREIGN KEY ("A") REFERENCES "Curriculo" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "_VagaCurriculo_B_fkey" FOREIGN KEY ("B") REFERENCES "Vaga" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "_VagaCurriculo_AB_unique" ON "_VagaCurriculo"("A", "B");

-- CreateIndex
CREATE INDEX "_VagaCurriculo_B_index" ON "_VagaCurriculo"("B");

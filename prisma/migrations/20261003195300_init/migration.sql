-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateEnum
CREATE TYPE "FieldRole" AS ENUM ('COLLECTOR', 'DUKA_AGENT', 'RESPONDER');

-- CreateEnum
CREATE TYPE "FieldUserStatus" AS ENUM ('PENDING', 'ACTIVE', 'SUSPENDED');

-- CreateEnum
CREATE TYPE "CollectionStatus" AS ENUM ('PENDING', 'COLLECTED', 'SKIPPED_NO_TRASH', 'DEFAULTED_UNPAID');

-- CreateEnum
CREATE TYPE "MaterialCategory" AS ENUM ('PET_PLASTIC', 'HDPE_RIGID', 'CORRUGATED_CARDBOARD', 'ALUMINUM');

-- CreateEnum
CREATE TYPE "HubWeighInSyncStatus" AS ENUM ('SYNCED', 'PENDING_HUB_QUEUE');

-- CreateEnum
CREATE TYPE "BountyJobStatus" AS ENUM ('AVAILABLE', 'CLAIMED', 'EN_ROUTE', 'PROOF_SUBMITTED', 'APPROVED');

-- CreateEnum
CREATE TYPE "SyncModule" AS ENUM ('ROUTE_UPDATE', 'HUB_WEIGH_IN', 'BOUNTY_CLEARANCE');

-- CreateEnum
CREATE TYPE "LedgerPartyType" AS ENUM ('RESIDENT', 'COLLECTOR', 'INDEPENDENT_PICKER', 'FIELD_WORKER');

-- CreateEnum
CREATE TYPE "LedgerEntryReason" AS ENUM ('HUB_BUYBACK', 'BOUNTY_PAYOUT', 'ADJUSTMENT');

-- CreateTable
CREATE TABLE "FieldWorkerUser" (
    "id" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "activeRole" "FieldRole" NOT NULL,
    "status" "FieldUserStatus" NOT NULL DEFAULT 'ACTIVE',
    "firstName" TEXT,
    "lastName" TEXT,
    "language" TEXT,
    "themePreference" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "FieldWorkerUser_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CollectorProfile" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "cboId" TEXT NOT NULL,
    "wardName" TEXT NOT NULL,
    "crewType" TEXT NOT NULL DEFAULT 'PUSHCART',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CollectorProfile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ResponderProfile" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "vehicleType" TEXT NOT NULL,
    "vehiclePlate" TEXT,
    "licenseNumber" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ResponderProfile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DukaAgentProfile" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "hubId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "DukaAgentProfile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CboOrganization" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "wardName" TEXT NOT NULL,
    "contactPhone" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CboOrganization_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Ward" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "region" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Ward_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Compound" (
    "id" TEXT NOT NULL,
    "wardId" TEXT NOT NULL,
    "lukuMeterNumber" TEXT,
    "compoundUnitNumber" TEXT,
    "residentPhoneHash" TEXT NOT NULL,
    "streetName" TEXT NOT NULL,
    "latitude" DOUBLE PRECISION NOT NULL,
    "longitude" DOUBLE PRECISION NOT NULL,
    "isPaidUp" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Compound_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CollectorRoute" (
    "id" TEXT NOT NULL,
    "cboId" TEXT NOT NULL,
    "collectorUserId" TEXT NOT NULL,
    "wardId" TEXT NOT NULL,
    "wardName" TEXT NOT NULL,
    "serviceDate" DATE NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CollectorRoute_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RouteStop" (
    "id" TEXT NOT NULL,
    "routeId" TEXT NOT NULL,
    "compoundId" TEXT NOT NULL,
    "status" "CollectionStatus" NOT NULL DEFAULT 'PENDING',
    "lockedLatitude" DOUBLE PRECISION,
    "lockedLongitude" DOUBLE PRECISION,
    "lockedAt" TIMESTAMP(3),
    "notes" TEXT,
    "updatedById" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "RouteStop_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DukaHub" (
    "id" TEXT NOT NULL,
    "hubCode" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "wardName" TEXT NOT NULL,
    "latitude" DOUBLE PRECISION NOT NULL,
    "longitude" DOUBLE PRECISION NOT NULL,
    "createdById" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DukaHub_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MaterialRate" (
    "id" TEXT NOT NULL,
    "category" "MaterialCategory" NOT NULL,
    "ratePerKgTzs" INTEGER NOT NULL,
    "effectiveAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "MaterialRate_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "HubWeighIn" (
    "id" TEXT NOT NULL,
    "sessionId" TEXT NOT NULL,
    "hubId" TEXT NOT NULL,
    "agentUserId" TEXT NOT NULL,
    "sellerDirectoryId" TEXT,
    "sellerType" "LedgerPartyType" NOT NULL,
    "materialCategory" "MaterialCategory" NOT NULL,
    "grossWeightKg" DOUBLE PRECISION NOT NULL,
    "tareWeightKg" DOUBLE PRECISION NOT NULL,
    "netWeightKg" DOUBLE PRECISION NOT NULL,
    "ratePerKgTzs" INTEGER NOT NULL,
    "totalPayoutTzs" INTEGER NOT NULL,
    "capturedAt" TIMESTAMP(3) NOT NULL,
    "syncStatus" "HubWeighInSyncStatus" NOT NULL DEFAULT 'SYNCED',
    "idempotencyKey" TEXT NOT NULL,
    "ledgerEntryId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "HubWeighIn_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SharedWallet" (
    "id" TEXT NOT NULL,
    "partyType" "LedgerPartyType" NOT NULL,
    "partyRef" TEXT NOT NULL,
    "balanceTzs" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "SharedWallet_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LedgerEntry" (
    "id" TEXT NOT NULL,
    "walletId" TEXT NOT NULL,
    "amountTzs" INTEGER NOT NULL,
    "reason" "LedgerEntryReason" NOT NULL,
    "referenceId" TEXT,
    "idempotencyKey" TEXT NOT NULL,
    "actorUserId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "LedgerEntry_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ResidentDirectory" (
    "id" TEXT NOT NULL,
    "phoneHash" TEXT NOT NULL,
    "displayName" TEXT NOT NULL,
    "qrToken" TEXT NOT NULL,
    "partyType" "LedgerPartyType" NOT NULL DEFAULT 'RESIDENT',
    "walletId" TEXT,
    "syncedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ResidentDirectory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DumpReport" (
    "id" TEXT NOT NULL,
    "reportId" TEXT NOT NULL,
    "latitude" DOUBLE PRECISION NOT NULL,
    "longitude" DOUBLE PRECISION NOT NULL,
    "wardName" TEXT,
    "estimatedVolumeM3" DOUBLE PRECISION NOT NULL,
    "reportedAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "DumpReport_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BountyJob" (
    "id" TEXT NOT NULL,
    "jobId" TEXT NOT NULL,
    "reportId" TEXT NOT NULL,
    "latitude" DOUBLE PRECISION NOT NULL,
    "longitude" DOUBLE PRECISION NOT NULL,
    "estimatedVolumeM3" DOUBLE PRECISION NOT NULL,
    "payoutAmountTzs" INTEGER NOT NULL,
    "status" "BountyJobStatus" NOT NULL DEFAULT 'AVAILABLE',
    "claimedByUserId" TEXT,
    "claimedAt" TIMESTAMP(3),
    "claimExpiresAt" TIMESTAMP(3),
    "completionProofUrl" TEXT,
    "clearedTimestamp" TIMESTAMP(3),
    "approvedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "BountyJob_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BountyClaim" (
    "id" TEXT NOT NULL,
    "jobId" TEXT NOT NULL,
    "responderUserId" TEXT NOT NULL,
    "claimedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "releasedAt" TIMESTAMP(3),
    "releaseReason" TEXT,

    CONSTRAINT "BountyClaim_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SyncReceipt" (
    "id" TEXT NOT NULL,
    "idempotencyKey" TEXT NOT NULL,
    "taskId" TEXT NOT NULL,
    "module" "SyncModule" NOT NULL,
    "responseJson" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SyncReceipt_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OtpChallenge" (
    "id" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "codeHash" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "attempts" INTEGER NOT NULL DEFAULT 0,
    "consumedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OtpChallenge_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "FieldWorkerUser_phone_key" ON "FieldWorkerUser"("phone");

-- CreateIndex
CREATE UNIQUE INDEX "CollectorProfile_userId_key" ON "CollectorProfile"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "ResponderProfile_userId_key" ON "ResponderProfile"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "DukaAgentProfile_userId_key" ON "DukaAgentProfile"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Ward_name_region_key" ON "Ward"("name", "region");

-- CreateIndex
CREATE UNIQUE INDEX "Compound_lukuMeterNumber_key" ON "Compound"("lukuMeterNumber");

-- CreateIndex
CREATE INDEX "Compound_wardId_idx" ON "Compound"("wardId");

-- CreateIndex
CREATE INDEX "Compound_residentPhoneHash_idx" ON "Compound"("residentPhoneHash");

-- CreateIndex
CREATE INDEX "CollectorRoute_collectorUserId_serviceDate_idx" ON "CollectorRoute"("collectorUserId", "serviceDate");

-- CreateIndex
CREATE UNIQUE INDEX "CollectorRoute_collectorUserId_serviceDate_key" ON "CollectorRoute"("collectorUserId", "serviceDate");

-- CreateIndex
CREATE INDEX "RouteStop_status_idx" ON "RouteStop"("status");

-- CreateIndex
CREATE UNIQUE INDEX "RouteStop_routeId_compoundId_key" ON "RouteStop"("routeId", "compoundId");

-- CreateIndex
CREATE UNIQUE INDEX "DukaHub_hubCode_key" ON "DukaHub"("hubCode");

-- CreateIndex
CREATE INDEX "DukaHub_wardName_idx" ON "DukaHub"("wardName");

-- CreateIndex
CREATE INDEX "MaterialRate_category_effectiveAt_idx" ON "MaterialRate"("category", "effectiveAt");

-- CreateIndex
CREATE UNIQUE INDEX "MaterialRate_category_effectiveAt_key" ON "MaterialRate"("category", "effectiveAt");

-- CreateIndex
CREATE UNIQUE INDEX "HubWeighIn_sessionId_key" ON "HubWeighIn"("sessionId");

-- CreateIndex
CREATE UNIQUE INDEX "HubWeighIn_idempotencyKey_key" ON "HubWeighIn"("idempotencyKey");

-- CreateIndex
CREATE UNIQUE INDEX "HubWeighIn_ledgerEntryId_key" ON "HubWeighIn"("ledgerEntryId");

-- CreateIndex
CREATE INDEX "HubWeighIn_hubId_capturedAt_idx" ON "HubWeighIn"("hubId", "capturedAt");

-- CreateIndex
CREATE INDEX "HubWeighIn_sellerDirectoryId_capturedAt_idx" ON "HubWeighIn"("sellerDirectoryId", "capturedAt");

-- CreateIndex
CREATE UNIQUE INDEX "SharedWallet_partyType_partyRef_key" ON "SharedWallet"("partyType", "partyRef");

-- CreateIndex
CREATE UNIQUE INDEX "LedgerEntry_idempotencyKey_key" ON "LedgerEntry"("idempotencyKey");

-- CreateIndex
CREATE INDEX "LedgerEntry_walletId_createdAt_idx" ON "LedgerEntry"("walletId", "createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "ResidentDirectory_phoneHash_key" ON "ResidentDirectory"("phoneHash");

-- CreateIndex
CREATE UNIQUE INDEX "ResidentDirectory_qrToken_key" ON "ResidentDirectory"("qrToken");

-- CreateIndex
CREATE UNIQUE INDEX "DumpReport_reportId_key" ON "DumpReport"("reportId");

-- CreateIndex
CREATE INDEX "DumpReport_latitude_longitude_idx" ON "DumpReport"("latitude", "longitude");

-- CreateIndex
CREATE UNIQUE INDEX "BountyJob_jobId_key" ON "BountyJob"("jobId");

-- CreateIndex
CREATE UNIQUE INDEX "BountyJob_reportId_key" ON "BountyJob"("reportId");

-- CreateIndex
CREATE INDEX "BountyJob_status_claimExpiresAt_idx" ON "BountyJob"("status", "claimExpiresAt");

-- CreateIndex
CREATE INDEX "BountyJob_latitude_longitude_idx" ON "BountyJob"("latitude", "longitude");

-- CreateIndex
CREATE INDEX "BountyClaim_jobId_claimedAt_idx" ON "BountyClaim"("jobId", "claimedAt");

-- CreateIndex
CREATE INDEX "BountyClaim_responderUserId_idx" ON "BountyClaim"("responderUserId");

-- CreateIndex
CREATE UNIQUE INDEX "SyncReceipt_idempotencyKey_key" ON "SyncReceipt"("idempotencyKey");

-- CreateIndex
CREATE INDEX "SyncReceipt_taskId_idx" ON "SyncReceipt"("taskId");

-- CreateIndex
CREATE INDEX "OtpChallenge_phone_createdAt_idx" ON "OtpChallenge"("phone", "createdAt");

-- AddForeignKey
ALTER TABLE "CollectorProfile" ADD CONSTRAINT "CollectorProfile_userId_fkey" FOREIGN KEY ("userId") REFERENCES "FieldWorkerUser"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CollectorProfile" ADD CONSTRAINT "CollectorProfile_cboId_fkey" FOREIGN KEY ("cboId") REFERENCES "CboOrganization"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ResponderProfile" ADD CONSTRAINT "ResponderProfile_userId_fkey" FOREIGN KEY ("userId") REFERENCES "FieldWorkerUser"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DukaAgentProfile" ADD CONSTRAINT "DukaAgentProfile_userId_fkey" FOREIGN KEY ("userId") REFERENCES "FieldWorkerUser"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DukaAgentProfile" ADD CONSTRAINT "DukaAgentProfile_hubId_fkey" FOREIGN KEY ("hubId") REFERENCES "DukaHub"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Compound" ADD CONSTRAINT "Compound_wardId_fkey" FOREIGN KEY ("wardId") REFERENCES "Ward"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CollectorRoute" ADD CONSTRAINT "CollectorRoute_cboId_fkey" FOREIGN KEY ("cboId") REFERENCES "CboOrganization"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CollectorRoute" ADD CONSTRAINT "CollectorRoute_collectorUserId_fkey" FOREIGN KEY ("collectorUserId") REFERENCES "CollectorProfile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CollectorRoute" ADD CONSTRAINT "CollectorRoute_wardId_fkey" FOREIGN KEY ("wardId") REFERENCES "Ward"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RouteStop" ADD CONSTRAINT "RouteStop_routeId_fkey" FOREIGN KEY ("routeId") REFERENCES "CollectorRoute"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RouteStop" ADD CONSTRAINT "RouteStop_compoundId_fkey" FOREIGN KEY ("compoundId") REFERENCES "Compound"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RouteStop" ADD CONSTRAINT "RouteStop_updatedById_fkey" FOREIGN KEY ("updatedById") REFERENCES "FieldWorkerUser"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DukaHub" ADD CONSTRAINT "DukaHub_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "FieldWorkerUser"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HubWeighIn" ADD CONSTRAINT "HubWeighIn_hubId_fkey" FOREIGN KEY ("hubId") REFERENCES "DukaHub"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HubWeighIn" ADD CONSTRAINT "HubWeighIn_agentUserId_fkey" FOREIGN KEY ("agentUserId") REFERENCES "FieldWorkerUser"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HubWeighIn" ADD CONSTRAINT "HubWeighIn_sellerDirectoryId_fkey" FOREIGN KEY ("sellerDirectoryId") REFERENCES "ResidentDirectory"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HubWeighIn" ADD CONSTRAINT "HubWeighIn_ledgerEntryId_fkey" FOREIGN KEY ("ledgerEntryId") REFERENCES "LedgerEntry"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LedgerEntry" ADD CONSTRAINT "LedgerEntry_walletId_fkey" FOREIGN KEY ("walletId") REFERENCES "SharedWallet"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LedgerEntry" ADD CONSTRAINT "LedgerEntry_actorUserId_fkey" FOREIGN KEY ("actorUserId") REFERENCES "FieldWorkerUser"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ResidentDirectory" ADD CONSTRAINT "ResidentDirectory_walletId_fkey" FOREIGN KEY ("walletId") REFERENCES "SharedWallet"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BountyJob" ADD CONSTRAINT "BountyJob_reportId_fkey" FOREIGN KEY ("reportId") REFERENCES "DumpReport"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BountyJob" ADD CONSTRAINT "BountyJob_claimedByUserId_fkey" FOREIGN KEY ("claimedByUserId") REFERENCES "FieldWorkerUser"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BountyClaim" ADD CONSTRAINT "BountyClaim_jobId_fkey" FOREIGN KEY ("jobId") REFERENCES "BountyJob"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BountyClaim" ADD CONSTRAINT "BountyClaim_responderUserId_fkey" FOREIGN KEY ("responderUserId") REFERENCES "FieldWorkerUser"("id") ON DELETE RESTRICT ON UPDATE CASCADE;


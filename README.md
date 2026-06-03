<div align="center">

# <span style="color:#A07320">RGMC AL Extension v2</span>

<span style="color:#666">Business Central customization for RGMC — barcode scanning, warehouse ops, retail APIs, and print reports</span>

[![AL Language](https://img.shields.io/badge/AL-Language-0078D4?style=flat-square&logo=microsoftazure)](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-programming-in-al)
[![BC Platform](https://img.shields.io/badge/BC_Platform-27.0-blue?style=flat-square)](https://learn.microsoft.com/en-us/dynamics365/business-central/)
[![LS Central](https://img.shields.io/badge/LS_Central-27.1.8-orange?style=flat-square)](https://www.lsretail.com/)
[![Runtime](https://img.shields.io/badge/Runtime-16.1-lightgrey?style=flat-square)]()
[![Version](https://img.shields.io/badge/Extension-v1.0.1.10-green?style=flat-square)]()

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Tech Stack](#-tech-stack)
- [Features](#-features)
- [Pages & Objects](#-pages--objects)
- [Project Structure](#-project-structure)
- [Setup & Installation](#-setup--installation)
- [Running & Deploying](#-running--deploying)
- [API Endpoints](#-api-endpoints)
- [Reports & Layouts](#-reports--layouts)
- [Authentication Flow](#-authentication-flow)
- [Core Data Flow](#-core-data-flow)
- [Table Extensions & Data Model](#-table-extensions--data-model)
- [Dependencies](#-dependencies)
- [License](#-license)

---

## 🏢 Overview

This is a **Microsoft Dynamics 365 Business Central AL extension** built for RGMC (Glenn Eregia). It extends and customizes the standard Business Central and LS Central (LS Retail) platform to meet RGMC's retail and warehouse operations needs.

**What it does:**

- Adds **real-time barcode scanner pages** for warehouse picks, transfer order shipping/receiving, and warehouse receipts — operators scan items one at a time and quantities are updated live, with excess-scan guards.
- Extends **Warehouse Picks** with a mandatory PIN-based authentication gate before registering a pick, and tracks the device/owner on both the pick and its registered record.
- Provides **custom RDLC print reports**: the Warehouse Shipment DR (Delivery Receipt), the LM Pull-out slip for transfer orders, and the LM DR for warehouse shipments — all with barcode encoding (Code39) and price-as-of-date lookups.
- Exposes **OData/REST API pages** (publisher `rgmc`, group `rgmccustom`, version `v1.0`) for retail customers, contacts, sales return orders, and sales return order lines — enabling external systems (POS, mobile apps, integration middleware) to read and write BC data.
- Extends standard pages and tables with RGMC-specific fields: Remarks on Transfer Orders, Store Code on Location, Device Id/Owner and No. of Boxes on Warehouse Activity, Occupation/Company/Registration No. on Member Contacts.
- Extends standard reports with additional columns: Pre-Assigned Doc No. on APV, Due Date on Purchase Invoice, Transfer Order No. and SRP price on Transfer Receipt, Name 2 on Summary List of Sales.

**Deployed against:** Microsoft Cloud Sandbox environment named `DEV`, tenant `ca3ca144-09d9-42dd-920a-c72aedd54dd6`.

---

## 🛠 Tech Stack

| Layer | Technology | Version |
|---|---|---|
| Language | AL (Application Language) | Runtime 16.1 |
| Platform | Microsoft Dynamics 365 Business Central | 27.0 (platform) / 27.5 (application) |
| Retail Layer | LS Central (LS Retail) | 27.1.8.3261 |
| Tax (PH) | Associates 365 PHCAS | 27.1.0.4 |
| Tax (PH) | Associates 365 PHTAX | 27.3.0.0 |
| Base App | Microsoft Base Application | 27.5.46862.50615 |
| System App | Microsoft System Application | 27.5.46862.46929 |
| Report Layout | RDLC (SQL Server Reporting Services) | — |
| Barcode Engine | IDAutomation1D (Code39 symbology) | BC built-in |
| IDE | VS Code + AL Language Extension | — |
| Target Environment | Microsoft Cloud Sandbox (`DEV`) | — |

---

## ✨ Features

### 📷 Barcode Scanner Pages

- **Transfer Order Shipping Scanner** (`page 50100`) — Scan items against an open Transfer Order to set `Qty. to Ship`. Guards against over-scanning by checking `Outstanding Quantity`. Auto-clears the field after each scan for rapid multi-scan workflow.
- **Transfer Order Receive Scanner** (`page 50101`) — Scan received items against a Transfer Order to increment `Qty. to Receive`. Guards against excess receiving by checking `Quantity Shipped`. Shows remaining qty in real time.
- **Warehouse Pick Scanner** (`page 50102`) — Scan items in a Warehouse Pick, updating both the **Take** line (`Qty. to Handle`) and its corresponding **Place** line automatically. Displays real-time remaining qty.
- **Warehouse Receipt Scanner** (`page 50126`) — Scan items on a Warehouse Receipt to update `Qty. to Receive`. Excess-scan protection included.

### 🔐 Pick Registration Authentication

- Before any Warehouse Pick can be registered, a **PIN dialog** (`page 50111 "Register Pick Login"`) fires via `OnBeforeRegisterActivityYesNo` event subscription.
- Authentication validates the entered User ID + PIN against the `USER` dimension value table.
- On success, the authenticated user's ID is written to `Device Id / Owner` on the Warehouse Activity Header and propagated to the Registered Whse. Activity Header after registration.

### 🖨 Print Reports

- **Warehouse Shipment DR** (`report 50100`) — prints a delivery receipt from Warehouse Shipment lines, resolving destination name, vendor code, TIN, business style, store code, LS unit price as of posting date, and line amounts. Layout: `WarehouseShipment.rdlc`.
- **Print LM DR** (`report 50101`) — prints the LM Delivery Receipt from Warehouse Shipment lines using Code39 barcodes, SKU consolidation (deduplicates items sharing the same LM barcode reference), and price-as-of-date lookup. Layout: `PrintLMDR.rdlc`.
- **Print LM Pull-out** (`report 50102`) — same logic as LM DR but sourced from Transfer Order lines instead of Warehouse Shipment lines. Layout: `PrintLMPullOut.rdlc`.

### 🌐 OData REST APIs

Four fully CRUD-capable OData API pages under publisher `rgmc`, group `rgmccustom`, version `v1.0`:

- `retailCustomers` — Customer master with financial, address, and posting group fields.
- `salesReturnOrders` — Sales return order headers with embedded `salesReturnOrderLines`.
- `salesReturnOrderLines` — Line-level detail: item, quantities, pricing, VAT, return reason.
- `contacts` — CRM Contact (LSC Member Contact linked) with name, address, registration no., and salesperson.

### 🏗 Page & Table Extensions

- **Transfer Order** — adds `Remarks` (Text[250]) and exposes `External Document No.`; adds Scan Shipping, Scan Receiving, and Print LM Pull-out action buttons.
- **Transfer Order List** — extended table and list page.
- **Location** — adds `Store Code` (Code[20]) field.
- **Warehouse Activity Header** — adds `Device Id / Owner` (Text[100]) and `No. of Boxes` (Integer).
- **Registered Whse. Activity Hdr.** — mirrors the same two fields.
- **LSC Member Contact** — adds Occupation, Company, Remarks, Entry Amount, Registration No.
- **Items Page** — extension for RGMC item view.
- **Warehouse Pick** — extended page and picks list page.
- **Warehouse Shipment** — adds `No. of Boxes` display field (read-only).
- **Member Club Receipt** — page and table extension.
- **Sales Order** — total quantity extension.
- **Posted Purchase Invoice** — page extension.
- **Posted Warehouse Receipt** — custom list and card pages.
- **Posted Transfer Receipt / Shipment** — custom card pages.
- **Registered Warehouse Pick** — custom list page.

### 📊 Report Extensions

| Extension | Extends | Added Columns |
|---|---|---|
| `RALPurchaseInvoice Ext` (50100) | Report 80135 | `Due Date` on Purchase Header |
| `RALAccountsPayableVoucher Ext` (50101) | Report 80134 | `Pre-Assigned No.` on Posted Invoice |
| `RAL_SummaryListOfSales_Ext` (50102) | RAL Summary List of Sales | `Name 2` resolved from Customer |
| `Transfer Receipt Ext` (50103) | Transfer Receipt | `Transfer Order No.` + `SRP` (price-as-of-date) |

### 🧾 LS Central / PH Tax Integration

Depends on PHCAS (`Associates 365`) for Philippine CAS compliance and PHTAX for Philippine tax computation, both pinned to specific patch versions.

---

## 📄 Pages & Objects

| Object Type | ID | Name | Purpose |
|---|---|---|---|
| Page | 50100 | Transfer Order Scanner | Shipping barcode scanner |
| Page | 50101 | Transfer Order Receive Scanner | Receiving barcode scanner |
| Page | 50102 | Warehouse Pick Scanner | Warehouse pick barcode scanner |
| Page | 50111 | Register Pick Login | PIN authentication dialog |
| Page | 50126 | Warehouse Receipt Scanner | Warehouse receipt barcode scanner |
| Page | 50200 | LSC Retail Customer API | OData API — Customers |
| Page | 50201 | LSC Retail SRO API | OData API — Sales Return Orders |
| Page | 50202 | LSC Retail SRO Lines API | OData API — SRO Lines |
| Page | 50203 | LSC Retail Contact API | OData API — Contacts |
| Report | 50100 | Warehouse Shipment | Ordinary DR print |
| Report | 50101 | Print LMDR | LM Delivery Receipt |
| Report | 50102 | Print LMPullOut | LM Pull-out slip |
| Codeunit | 50120 | RGMCRegisterPickAuth | Event subscriber for pick auth |
| PageExt | 50102 | RGMC Transfer Order Ext | Remarks + Ext Doc No. fields |
| PageExt | 50110 | WhseShipmentHeaderExtPage | No. of Boxes display |
| PageExt | 50124 | RGMCTrasferOrderBtn | Scan + Print action buttons |
| TableExt | 50100 | RGMCContactTableExt | Member Contact extra fields |
| TableExt | 50102 | Transfer Header Ext | Remarks field |
| TableExt | 50103 | RGMC Warehouse Pick Ext | Device Id / Owner + No. of Boxes |
| TableExt | 50104 | RGMC Registered Whse Pick Ext | Device Id / Owner + No. of Boxes |
| TableExt | 50106 | RGMCLocationExt | Store Code field |
| ReportExt | 50100 | RALPurchaseInvoice Ext | Due Date column |
| ReportExt | 50101 | RALAccountsPayableVoucher Ext | Pre-Assigned No. column |
| ReportExt | 50102 | RAL_SummaryListOfSales_Ext | Name 2 column |
| ReportExt | 50103 | Transfer Receipt Ext | Transfer Order No. + SRP |

---

## 📁 Project Structure

```
RGMC_AL_v2/
│
├── app.json                            # Extension manifest (id, version, dependencies)
├── .gitignore
│
├── source/
│   ├── RGMCBarcode/
│   │   ├── RGMCBarcodeScannerPage/
│   │   │   ├── TransferOrderPage/
│   │   │   │   ├── TransferOrderScanner.Button.al       # PageExt: adds Scan/Print actions to Transfer Order
│   │   │   │   ├── TransferOrderShippingScanner.al      # Page 50100: shipping barcode scanner
│   │   │   │   ├── TransferOrderReceiveScanner.al       # Page 50101: receiving barcode scanner
│   │   │   │   └── TransferOrderPrintLMPullOut.al       # Report 50102: LM pull-out slip
│   │   │   ├── WarehousePicksPage/
│   │   │   │   ├── WarehouseScanner.Page.al             # Page 50102: pick barcode scanner
│   │   │   │   └── WarehouseScanner.Button.al           # PageExt: adds scan button to Warehouse Picks
│   │   │   └── WarehouseReceiptPage/
│   │   │       ├── RGMCWarehouseReceiptScanner.Page.al  # Page 50126: receipt barcode scanner
│   │   │       └── RGMCWarehouseReceipt.Button.al       # PageExt: adds scan button to Warehouse Receipt
│   │   ├── RGMCTransferOrders/
│   │   │   └── RGMCTransferOrdersPageExt.al             # Transfer orders list page extension
│   │   ├── RGMCWarehousePick/
│   │   │   └── RGMCWarehousePick.al                     # Warehouse pick page extension
│   │   └── RGMCWarehouseReceipt/
│   │       └── RGMCWarehouseReceipt.al                  # Warehouse receipt page extension
│   │
│   ├── RGMCWarehousePick/
│   │   ├── codeunit/
│   │   │   └── RGMCWarehousePickCodeUnit.al             # Codeunit 50120: pick auth event subscriber
│   │   ├── login/
│   │   │   └── RGMCAuthenticationPage.al                # Page 50111: PIN login dialog
│   │   ├── RGMCWarehousePickPageExt.al                  # Whse. Pick page extension
│   │   ├── RGMCWarehousePicksPageExt.al                 # Whse. Picks list extension
│   │   └── RGMCWarehousePickTableExt.al                 # TableExt 50103: adds Device Id / Owner + No. of Boxes
│   │
│   ├── RGMCWarehouseShipment/
│   │   ├── RGMCWarehouseShipmentPage.al                 # PageExt: adds No. of Boxes to shipment header
│   │   ├── RGMCWarehouseShipmentsPage.al                # Shipments list extension
│   │   └── RGMCWarehouseShipmentTable.al                # Table extension for shipment header
│   │
│   ├── RGMCPrintExtension/
│   │   ├── RGMCOrdinaryDRDialog.al                      # Report 50100: Warehouse Shipment DR
│   │   ├── RGMCWarehouseShipmentLMDR.Print.al           # Report 50101: Print LM DR
│   │   └── RGMCOrdinaryDRButton.al                      # PageExt: adds DR print action
│   │
│   ├── RGMCCustomer/
│   │   └── 50200LSCRetailCustomerAPI.al                 # Page 50200: OData Customer API
│   │
│   ├── RGMCSalesReturnOrder/
│   │   ├── 50201LSCRetailSalesReturnOrderAPI.al         # Page 50201: OData SRO header API
│   │   └── 50202LSCRetailSalesReturnOrderLinesAPI.al    # Page 50202: OData SRO lines API
│   │
│   ├── RGMCMemberContact/
│   │   ├── 50203LSCRetailContactAPI.al                  # Page 50203: OData Contact API
│   │   ├── RGMCContactRegNoExt.TableExt.al              # Contact Registration No. extension
│   │   ├── RGMCMemberContactPageExt.al                  # Member Contact page extension
│   │   └── RGMCMemberContactTableExt.al                 # TableExt 50100: adds 5 custom fields
│   │
│   ├── RGMCTransferOrder/
│   │   ├── RGMCTransferOrderPageExt.al                  # PageExt 50102: Remarks + Ext Doc No.
│   │   ├── RGMCTransferOrderTableExt.al                 # TableExt 50102: Remarks field
│   │   ├── RGMCTransferOrderListPageExt.al              # Transfer Order List page extension
│   │   ├── RGMCTransferOrderListTableExt.al             # Transfer Order List table extension
│   │   └── RGMCTransferOrderSubFormExt.al               # Transfer Order SubForm extension
│   │
│   ├── RGMCLocation/
│   │   ├── Loacation.tableext.al                        # TableExt 50106: Store Code on Location
│   │   └── Location.pageext.al                          # Location page extension
│   │
│   ├── RGMCRegisteredWarehousePick/
│   │   ├── RGMCRegisteredWhsePickPage.al                # Registered Whse. Pick list page
│   │   └── RGMCRegisteredWhsePickTable.al               # TableExt 50104: Device Id / Owner + No. of Boxes
│   │
│   ├── RGMCReportExtentions/
│   │   ├── APVReportExt.al                              # ReportExt 50101: APV + Pre-Assigned No.
│   │   ├── PurchaseInvoiceReportExt.al                  # ReportExt 50100: Purchase Invoice + Due Date
│   │   ├── SummaryListofSalesReportExt.al               # ReportExt 50102: Summary Sales + Name 2
│   │   ├── TransferReceiptReportExt.al                  # ReportExt 50103: Transfer Receipt + SRP
│   │   └── CalculateInventoryExt.al                     # Calculate Inventory report extension
│   │
│   ├── RGMCItems/
│   │   └── RGMCItemsPageExt.al                          # Items page extension
│   │
│   ├── RGMCSalesOrder/
│   │   └── RGMCTotalQuantityPageExt.al                  # Sales Order total qty extension
│   │
│   ├── RGMCMemberClubReceipt/
│   │   ├── RGMCMemberClubReceiptPageExt.al              # Member Club Receipt page extension
│   │   └── RGMCMemberClubReceiptTableExt.al             # Member Club Receipt table extension
│   │
│   ├── RGMCPostedPurchaseInvoice/
│   │   └── RGMCPostedPurchaseInvoicePageExt.al          # Posted Purchase Invoice page extension
│   │
│   ├── RGMCPostedTransferReceipt/
│   │   └── PostedTransferReceipt.Page.al                # Posted Transfer Receipt card page
│   │
│   ├── RGMCPostedTransferShipments/
│   │   └── PostedTransferShipment.Page.al               # Posted Transfer Shipment card page
│   │
│   ├── RGMCPostedWarehouseReceipt/
│   │   ├── PostedWarehouseReceipt.Page.al               # Posted Warehouse Receipt card page
│   │   └── PostedWarehouseReceiptList.Page.al           # Posted Warehouse Receipt list page
│   │
│   └── RGMCPrintReceiptExt/
│       └── RGMCPrintReceiptExt.al                       # Print Receipt page extension
│
└── Layouts/
    ├── WarehouseShipment.rdlc                            # RDLC: Warehouse Shipment DR
    ├── PrintLMDR.rdlc                                    # RDLC: LM Delivery Receipt
    └── PrintLMPullOut.rdlc                               # RDLC: LM Pull-out slip
```

---

## 🚀 Setup & Installation

### Prerequisites

| Tool | Version |
|---|---|
| Visual Studio Code | Latest stable |
| AL Language Extension | Latest (from VS Marketplace) |
| Business Central Sandbox | Platform 27.0 / App 27.5 |
| LS Central | 27.1.8.3261 installed on the tenant |
| Associates 365 PHCAS | 27.1.0.4 |
| Associates 365 PHTAX | 27.3.0.0 |

### Clone & Open

```bash
git clone <repository-url> RGMC_AL_v2
cd RGMC_AL_v2
code .
```

### Download Symbols

Once the project is open in VS Code with the AL extension active:

```
Ctrl+Shift+P → AL: Download Symbols
```

This populates `.alpackages/` with all dependency `.app` files from the connected sandbox. The sandbox connection is defined in `.vscode/launch.json`.

> ⚠️ `.alpackages/` is gitignored — symbols are always fetched fresh from the tenant, never committed.

---

## ▶ Running & Deploying

### Publish to Sandbox (DEV)

```
F5  (or Ctrl+Shift+P → AL: Publish)
```

This compiles the extension and publishes it to the `DEV` sandbox environment. The browser opens automatically to BC startup page 22.

### Debug

```
F5   → attaches debugger to the sandbox session
```

Set breakpoints in any `.al` file. The launch config has `breakOnError: All`, `enableLongRunningSqlStatements: true`, and `enableSqlInformationDebugger: true` for full diagnostics.

### Build (without publish)

```
Ctrl+Shift+B  (or Ctrl+Shift+P → AL: Build)
```

Produces a compiled `.app` file in the project root, named:

```
RGMC Publisher_RGMC Glenn Eregia_<version>.app
```

> 📌 Compiled `.app` files are gitignored. Increment `version` in `app.json` before each build intended for deployment.

### Environment Config (`launch.json`)

```json
{
  "name": "Microsoft cloud sandbox",
  "request": "launch",
  "type": "al",
  "environmentType": "Sandbox",
  "environmentName": "DEV",
  "startupObjectId": 22,
  "startupObjectType": "Page",
  "tenant": "ca3ca144-09d9-42dd-920a-c72aedd54dd6"
}
```

---

## 🌐 API Endpoints

All APIs are OData v4. Base URL pattern:

```
https://<bc-host>/ODataV4/Company('<company>')/rgmc/rgmccustom/v1.0/<entitySet>
```

### <span style="color:#2a9d8f">Customers</span>

| Method | Entity Set | Description |
|---|---|---|
| `GET` | `retailCustomers` | List all customers |
| `GET` | `retailCustomers(<systemId>)` | Get single customer |
| `POST` | `retailCustomers` | Create customer |
| `PATCH` | `retailCustomers(<systemId>)` | Update customer |
| `DELETE` | `retailCustomers(<systemId>)` | Delete customer (blocked if balance ≠ 0) |

**POST payload shape:**
```json
{
  "name": "RGMC Store Makati",
  "customerPostingGroup": "DOMESTIC",
  "genBusPostingGroup": "DOMESTIC",
  "paymentTermsCode": "30D",
  "vatRegistrationNo": "123-456-789-000"
}
```

### <span style="color:#2a9d8f">Sales Return Orders</span>

| Method | Entity Set | Description |
|---|---|---|
| `GET` | `salesReturnOrders` | List all return orders |
| `GET` | `salesReturnOrders(<systemId>)` | Get order with embedded lines |
| `POST` | `salesReturnOrders` | Create return order |
| `PATCH` | `salesReturnOrders(<systemId>)` | Update (blocked if Released) |
| `DELETE` | `salesReturnOrders(<systemId>)` | Delete (blocked if Released) |

**POST payload shape:**
```json
{
  "sellToCustomerNo": "C00001",
  "postingDate": "2026-06-03",
  "externalDocumentNo": "RMA-2026-001"
}
```

### <span style="color:#2a9d8f">Sales Return Order Lines</span>

| Method | Entity Set | Description |
|---|---|---|
| `GET` | `salesReturnOrderLines` | List all lines (filter by documentNo) |
| `POST` | `salesReturnOrderLines` | Create line (quantity must be > 0) |
| `PATCH` | `salesReturnOrderLines(<systemId>)` | Update line |
| `DELETE` | `salesReturnOrderLines(<systemId>)` | Delete (blocked if Return Qty. Received ≠ 0) |

**POST payload shape:**
```json
{
  "documentNo": "SRO-0001",
  "lineType": "Item",
  "number": "ITEM001",
  "quantity": 5,
  "unitPrice": 199.00,
  "returnReasonCode": "DEFECTIVE"
}
```

### <span style="color:#2a9d8f">Contacts</span>

| Method | Entity Set | Description |
|---|---|---|
| `GET` | `contacts` | List all contacts |
| `GET` | `contacts(<systemId>)` | Get single contact |
| `POST` | `contacts` | Create contact (Name required) |
| `PATCH` | `contacts(<systemId>)` | Update contact |
| `DELETE` | `contacts(<systemId>)` | Delete (blocked if Person linked to Company) |

---

## 🖨 Reports & Layouts

| Report ID | Caption | Source Table | Layout File | Key Logic |
|---|---|---|---|---|
| 50100 | Warehouse Shipment | Warehouse Shipment Header | `WarehouseShipment.rdlc` | Resolves customer TIN, Business Style, Store Code, Vendor Code from Location; LS price as of posting date |
| 50101 | Print LMDR | Warehouse Shipment Header | `PrintLMDR.rdlc` | Consolidates lines by LM Item Reference SKU (Code39 encoded), deduplicates, sums qty by SKU; LS price as of posting date |
| 50102 | Print LMPullOut | Transfer Header | `PrintLMPullOut.rdlc` | Same SKU consolidation logic as LM DR but driven from Transfer Order lines; includes Vendor Code from Transfer-from Location |

### Barcode Encoding

All three reports use:
```al
BarcodeSymbology := Enum::"Barcode Symbology"::Code39;
BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
BarcodeTag := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
```

The `BarcodeTag` column in the RDLC layout renders using the IDAutomation1D barcode font.

---

## 🔐 Authentication Flow

The pick registration gate uses BC Dimension Values as a user directory.

```
1. Warehouse picker clicks "Register Pick" on the Whse. Pick Subform
2. OnBeforeRegisterActivityYesNo event fires (codeunit 50120)
3. "Register Pick Login" dialog opens (Page 50111)
4. User enters their User ID + PIN (masked field)
5. OnQueryClosePage validates:
     Worker.SetRange("Dimension Code", 'USER')
     Worker.SetRange(Name, UserID)
     Worker.SetRange(Code, PIN)
     → FindFirst() must succeed
6. On failure: Message('Invalid User ID or PIN.') → dialog stays open
7. On success: dialog closes with Action::OK
8. Codeunit writes authenticated UserID to
     Warehouse Activity Header."Device Id / Owner"
9. OnAfterRegisterActivityYesNo fires → UserID propagated to
     Registered Whse. Activity Hdr."Device Id / Owner"
10. Pick registration proceeds normally
```

> 💡 Users are stored as Dimension Values with Dimension Code = `USER`, Name = login ID, Code = PIN.

---

## 🔄 Core Data Flow

### Barcode Scanner Workflow (Shipping example)

```
Operator opens Transfer Order
    → clicks "Scan Shipping" action (PageExt 50124)
    → Page 50100 "Transfer Order Scanner" opens (modal, source = Transfer Header)

Operator scans item barcode
    → BarcodeTxt.OnValidate fires
    → ProcessScan(InputBarcode) called

ProcessScan:
    1. Validate barcode → Item.Get("No." = barcode)
       → Error if not found
    2. Lookup latest LS price → Price List Line (descending by Starting Date)
    3. Read Transfer Lines for this document + item
    4. Sum Outstanding Quantity across all lines
       → Error if total <= 0 (excess scan guard)
    5. Loop lines: for each line with Outstanding Qty > 0
         QtyToProcess = min(RemainingPerLine, ScanQty=1)
         TransferLine.Validate("Qty. to Ship", current + QtyToProcess)
         TransferLine.Modify(true)
    6. Display: Item Description, Sales Price, Qty. to Ship,
                Qty. Shipped, Remaining Qty
    7. BarcodeTxt cleared → ready for next scan
```

### Warehouse Pick Scanner (Take + Place sync)

```
Scan barcode
    → Validate against Warehouse Activity Lines (Action Type = Take)
    → Update Take line "Qty. to Handle"
    → Find matching Place line (same item, next line no. after Take)
    → Update Place line "Qty. to Handle" to match
    → CalcFields refreshes flow fields on Warehouse Activity Header
```

---

## 📦 Table Extensions & Data Model

### <span style="color:#2a9d8f">Transfer Header (TableExt 50102)</span>

| Field ID | Field Name | Type | Description |
|---|---|---|---|
| 50100 | Remarks | Text[250] | Free-text remarks on transfer order |

### <span style="color:#2a9d8f">Warehouse Activity Header (TableExt 50103)</span>

| Field ID | Field Name | Type | Description |
|---|---|---|---|
| 50100 | Device Id / Owner | Text[100] | ID of the picker who registered the pick |
| 50101 | No. of Boxes | Integer | Number of boxes for shipment |

### <span style="color:#2a9d8f">Registered Whse. Activity Hdr. (TableExt 50104)</span>

| Field ID | Field Name | Type | Description |
|---|---|---|---|
| 50100 | Device Id / Owner | Text[100] | Propagated from Activity Header on register |
| 50101 | No. of Boxes | Integer | Propagated from Activity Header on register |

### <span style="color:#2a9d8f">Location (TableExt 50106)</span>

| Field ID | Field Name | Type | Description |
|---|---|---|---|
| 50100 | Store Code | Code[20] | RGMC store identifier on the location |

### <span style="color:#2a9d8f">LSC Member Contact (TableExt 50100)</span>

| Field ID | Field Name | Type | Description |
|---|---|---|---|
| 50100 | Occupation | Text[100] | Member's occupation |
| 50101 | Company | Text[100] | Member's company |
| 50102 | Remarks | Text[250] | Free-text remarks |
| 50103 | Entry Amount | Decimal | Member entry amount |
| 50104 | Registration No. | Text[30] | Member registration number |

---

## 🔗 Dependencies

| Publisher | App Name | App ID | Version |
|---|---|---|---|
| LS Retail | LS Central | `5ecfc871-5d82-43f1-9c54-59685e82318d` | 27.1.8.3261 |
| Microsoft | Base Application | `437dbf0e-84ff-417a-965d-ed2bb9650972` | 27.5.46862.50615 |
| Associates 365 | PHCAS | `1f4a208a-3e92-4d5c-ada4-effa705d199a` | 27.1.0.4 |
| Associates 365 | PHTAX | `dc4b3ddf-1b1b-4caa-8683-3c9e1b6d322d` | 27.3.0.0 |
| Microsoft | System Application | `63ca2fa4-4f03-4f2b-a480-172fef340d3f` | 27.5.46862.46929 |

> ⚠️ All dependency `.app` files are installed on the target tenant and downloaded locally via `AL: Download Symbols`. They are **not** committed to this repository.

---

## 📜 License

This extension is proprietary software developed for **RGMC**. All rights reserved.

Not for redistribution or use outside the RGMC Business Central tenant without explicit authorization.

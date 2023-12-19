report 50012 UpdatePostingDate
{

    ProcessingOnly = true;
    ApplicationArea = All;
    Caption = 'Update Posting Date';
    UsageCategory = ReportsAndAnalysis;
    Permissions = tabledata "Purch. Inv. Header" = RM, tabledata "G/L Entry" = RM, tabledata "Vendor Ledger Entry" = RM, tabledata "Detailed Vendor Ledg. Entry" = RM, tabledata "Sales Invoice Header" = RM, tabledata "Cust. Ledger Entry" = RM, tabledata "Detailed Cust. Ledg. Entry" = RM, tabledata "Bank Account Ledger Entry" = RM, tabledata "VAT Entry" = RM, tabledata "Item Ledger Entry" = RM, tabledata "Value Entry" = RM, tabledata "Warehouse Entry" = RM, tabledata "Posted Gen. Journal Line" = RM;

    dataset
    {

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(DocumentNo; DocumentNo)
                    {
                        ApplicationArea = All;

                    }
                    field(PrevPostingDate; PrevPostingDate)
                    {
                        ApplicationArea = All;

                    }
                    field(PostingDate; PostingDate)
                    {
                        ApplicationArea = All;

                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }



    trigger OnPreReport()
    var
        PurInvoiceHdr: Record "Purch. Inv. Header";
        GLEntry: Record "G/L Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        DetVendorLedgerEntry: Record "Detailed Vendor Ledg. Entry";
        SaleInvHdr: Record "Sales Invoice Header";
        custLedgEntry: Record "Cust. Ledger Entry";
        DtlCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        BankAccLedgerEntry: Record "Bank Account Ledger Entry";
        //
        VatEntry: Record "VAT Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        WarehouseEntry: Record "Warehouse Entry";
        PostedGenJournalline: Record "Posted Gen. Journal Line";

    begin
        if DocumentNo = '' then
            Error('Document No Must have value');
        if PostingDate = 0D then
            Error('Posting Date Must have value');
        PurInvoiceHdr.Reset();
        PurInvoiceHdr.SetFilter("No.", DocumentNo);
        if PurInvoiceHdr.FindSet() then begin
            PurInvoiceHdr.ModifyAll("Posting Date", PostingDate);

        end;
        GLEntry.Reset();
        GLEntry.SetFilter("Document No.", DocumentNo);
        if PrevPostingDate <> 0D then
            GLEntry.SetRange("Posting Date", PrevPostingDate);
        if GLEntry.FindSet() then
            GLEntry.ModifyAll("Posting Date", PostingDate);

        VendorLedgerEntry.Reset();
        VendorLedgerEntry.SetFilter("Document No.", DocumentNo);
        if PrevPostingDate <> 0D then
            VendorLedgerEntry.SetRange("Posting Date", PrevPostingDate);
        if VendorLedgerEntry.FindSet() then
            VendorLedgerEntry.ModifyAll("Posting Date", PostingDate);

        DetVendorLedgerEntry.Reset();
        DetVendorLedgerEntry.SetFilter("Document No.", DocumentNo);
        if PrevPostingDate <> 0D then
            DetVendorLedgerEntry.SetRange("Posting Date", PrevPostingDate);
        if DetVendorLedgerEntry.FindSet() then
            DetVendorLedgerEntry.ModifyAll("Posting Date", PostingDate);

        SaleInvHdr.Reset();
        SaleInvHdr.SetFilter("No.", DocumentNo);
        if PrevPostingDate <> 0D then
            SaleInvHdr.SetRange("Posting Date", PrevPostingDate);
        if SaleInvHdr.FindSet() then begin
            SaleInvHdr.ModifyAll("Posting Date", PostingDate);
        end;

        custLedgEntry.Reset();
        custLedgEntry.SetFilter("Document No.", DocumentNo);
        if PrevPostingDate <> 0D then
            custLedgEntry.SetRange("Posting Date", PrevPostingDate);
        if custLedgEntry.FindSet() then
            custLedgEntry.ModifyAll("Posting Date", PostingDate);

        DtlCustLedgEntry.Reset();
        DtlCustLedgEntry.SetFilter("Document No.", DocumentNo);
        if PrevPostingDate <> 0D then
            DtlCustLedgEntry.SetRange("Posting Date", PrevPostingDate);
        if DtlCustLedgEntry.FindSet() then
            DtlCustLedgEntry.ModifyAll("Posting Date", PostingDate);

        BankAccLedgerEntry.Reset();
        BankAccLedgerEntry.SetFilter("Document No.", DocumentNo);
        if PrevPostingDate <> 0D then
            BankAccLedgerEntry.SetRange("Posting Date", PrevPostingDate);
        if BankAccLedgerEntry.FindSet() then
            BankAccLedgerEntry.ModifyAll("Posting Date", PostingDate);

        VatEntry.Reset();
        VatEntry.SetFilter("Document No.", DocumentNo);
        if PrevPostingDate <> 0D then
            VatEntry.SetRange("Posting Date", PrevPostingDate);
        if VatEntry.FindSet() then
            VatEntry.ModifyAll("Posting Date", PostingDate);

        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetFilter("Document No.", DocumentNo);
        if PrevPostingDate <> 0D then
            ItemLedgerEntry.SetRange("Posting Date", PrevPostingDate);
        if ItemLedgerEntry.FindSet() then
            ItemLedgerEntry.ModifyAll("Posting Date", PostingDate);

        ValueEntry.Reset();
        ValueEntry.SetFilter("Document No.", DocumentNo);
        if PrevPostingDate <> 0D then
            ValueEntry.SetRange("Posting Date", PrevPostingDate);
        if ValueEntry.FindSet() then
            ValueEntry.ModifyAll("Posting Date", PostingDate);

        WarehouseEntry.Reset();
        WarehouseEntry.SetFilter("Whse. Document No.", DocumentNo);
        if PrevPostingDate <> 0D then
            WarehouseEntry.SetRange("Registering Date", PrevPostingDate);
        if WarehouseEntry.FindSet() then
            WarehouseEntry.ModifyAll("Registering Date", PostingDate);

        PostedGenJournalline.Reset();
        PostedGenJournalline.SetFilter("Document No.", DocumentNo);
        IF PrevPostingDate <> 0D then
            PostedGenJournalline.SetRange("Posting Date", PrevPostingDate);
        if PostedGenJournalline.FindSet() then
            PostedGenJournalline.ModifyAll("Posting Date", PostingDate);


    end;

    trigger OnPostReport()
    begin
        Message('Updated');
    end;

    var
        //DocumentNo: Code[20];
        DocumentNo: Text[250];
        PostingDate: Date;
        PrevPostingDate: Date;

}
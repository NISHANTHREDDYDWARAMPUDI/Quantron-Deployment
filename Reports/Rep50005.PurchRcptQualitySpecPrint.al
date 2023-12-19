report 50005 "Purch Rcpt. Quality Spec Print"
{
    ApplicationArea = All;
    RDLCLayout = 'Reports\Layouts\PurchRcptQualitySpecPrint.rdl';
    Caption = 'Purchase Receipt Quality Spec Print';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Purch. Rcpt QS Line"; "Purch. Rcpt QS Line")
        {
            column(PurchRcptNoLbl; PurchRcptNoLbl)
            {
            }
            column(PurchRcptLineNoLbl; PurchRcptLineNoLbl)
            {
            }
            column(SpecIDLbl; SpecIDLbl)
            {
            }
            column(DateLbl; DateLbl)
            {
            }
            column(SignatureLbl; SignatureLbl)
            {
            }
            column(SpecificationLbl; SpecificationLbl)
            {
            }
            column(ValueLbl; ValueLbl)
            {
            }
            column(SpecID; "Spec ID")
            {
            }
            column(Specification_Group; "Specification Group")
            {
            }
            column(Specification; Specification)
            {
            }
            column(ActualValue; ActualValue)
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(DocumentNo_PurchRcptQSLine; "Document No.")
            {
            }
            column(LineNo_PurchRcptQSLine; "Line No.")
            {
            }
            column(RcptLineNo_PurchRcptQSLine; "Rcpt. Line No.")
            {
            }

            column(ResourceID; PurchRcptQSHdr."Resource ID")
            {
            }
            column(ResourceIDLbl; ResourceIDLbl)
            {
            }
            column(Resource_Name; Resource.Name)
            {
            }
            trigger OnAfterGetRecord()
            begin
                Clear(ActualValue);
                if Value <> '' then
                    ActualValue := Value
                else
                    if Check then
                        ActualValue := YesLbl
                    else
                        ActualValue := NoLbl;

                if not (PurchRcptQSHdr.Get("Document No.", "Rcpt. Line No.", "Spec ID")) then
                    Clear(PurchRcptQSHdr);

                if not (Resource.Get(PurchRcptQSHdr."Resource ID")) then
                    Clear(Resource);
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get();
                CompanyInfo.CalcFields(Picture);
            end;
        }
    }
    var
        PurchRcptQSHdr: Record "Purch. Rcpt QS Header";
        CompanyInfo: Record "Company Information";
        Resource: Record Resource;
        ActualValue: Text[1000];
        YesLbl: Label 'Yes';
        NoLbl: Label 'No';
        PurchRcptNoLbl: Label 'Purchase Receipt No.';
        PurchRcptLineNoLbl: Label 'Purchase Receipt Line No.';
        SpecIDLbl: Label 'Spec ID';
        DateLbl: Label 'Date';
        SignatureLbl: Label 'Signature';
        SpecificationLbl: Label 'Specification';
        ValueLbl: Label 'Value';
        ResourceIDLbl: Label 'Resource ID';
}

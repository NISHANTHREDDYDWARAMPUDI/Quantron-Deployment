report 50004 "Quality Spec Print"
{
    ApplicationArea = All;
    RDLCLayout = 'Reports\Layouts\QualitySpecPrint.rdl';
    Caption = 'Quality Spec Print';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(ProdOrdRoutingQSLine; "Prod Ord. Routing QS Line")
        {
            DataItemTableView = sorting(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.", "Spec ID", "Line No.");
            column(ProdOrderNoLbl; ProdOrderNoLbl)
            {
            }
            column(RoutingNoLbl; RoutingNoLbl)
            {
            }
            column(RoutingRefNoLbl; RoutingRefNoLbl)
            {
            }
            column(OperationNoLbl; OperationNoLbl)
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
            column(Status; Status)
            {
            }
            column(ProdOrderNo; "Prod. Order No.")
            {
            }
            column(RoutingReferenceNo; "Routing Reference No.")
            {
            }
            column(RoutingNo; "Routing No.")
            {
            }
            column(OperationNo; "Operation No.")
            {
            }
            column(ActualValue; ActualValue)
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(LineNo_ProdOrdRoutingQSLine; "Line No.")
            {
            }
            column(ResourceID; ProdOrderRoutingQSHdr."Resource ID")
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

                if not (ProdOrderRoutingQSHdr.Get(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.", "Spec ID")) then
                    Clear(ProdOrderRoutingQSHdr);

                if not (Resource.Get(ProdOrderRoutingQSHdr."Resource ID")) then
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
        ProdOrderRoutingQSHdr: Record "Prod Ord. Routing QS Header";
        CompanyInfo: Record "Company Information";
        Resource: Record Resource;
        ActualValue: Text[1000];
        YesLbl: Label 'Yes';
        NoLbl: Label 'No';
        ProdOrderNoLbl: Label 'Prod. Order No.';
        RoutingNoLbl: Label 'Routing No.';
        OperationNoLbl: Label 'Operation No.';
        SpecIDLbl: Label 'Spec ID';
        RoutingRefNoLbl: Label 'Routing Reference No.';
        DateLbl: Label 'Date';
        SignatureLbl: Label 'Signature';
        SpecificationLbl: Label 'Specification';
        ValueLbl: Label 'Value';
        ResourceIDLbl: Label 'Resource ID';
}

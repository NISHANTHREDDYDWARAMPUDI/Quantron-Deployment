tableextension 50032 TrackingSpecification extends "Tracking Specification"
{
    fields
    {
        field(50000; Revision; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Revision';
        }
    }
    procedure InitFromProdOrderCompFromLocation(var ProdOrderComp: Record "Prod. Order Component")
    begin
        Init();
        SetItemData(
            ProdOrderComp."Item No.", ProdOrderComp.Description, ProdOrderComp."Transfer-from Location Code", ProdOrderComp."Variant Code",
            ProdOrderComp."Transfer-from Bin Code", ProdOrderComp."Qty. per Unit of Measure");
        SetSource(
            DATABASE::"Prod. Order Component", ProdOrderComp.Status.AsInteger(), ProdOrderComp."Prod. Order No.", ProdOrderComp."Line No.", '',
            ProdOrderComp."Prod. Order Line No.");
        SetQuantities(
            ProdOrderComp."Remaining Qty. (Base)", ProdOrderComp."Remaining Quantity", ProdOrderComp."Remaining Qty. (Base)",
            ProdOrderComp."Remaining Quantity", ProdOrderComp."Remaining Qty. (Base)",
            ProdOrderComp."Expected Qty. (Base)" - ProdOrderComp."Remaining Qty. (Base)",
            ProdOrderComp."Expected Qty. (Base)" - ProdOrderComp."Remaining Qty. (Base)");
    end;
}

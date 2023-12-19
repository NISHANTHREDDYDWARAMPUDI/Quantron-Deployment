codeunit 50004 ItemAPI
{
    trigger OnRun()
    begin

    end;

    procedure UpdateItemLinks(itemNo: Code[20]; apiLink: Text): Text
    begin
        ItemRec.get(itemNo);
        Links2.Reset();
        Links2.SetRange("Record ID", ItemRec.RecordId);
        Links2.SetRange(URL1, apiLink);
        if Links2.FindFirst() then
            exit(AlreadyTxt);
        Links.Reset();
        if Links.FindLast() then
            Entryno := Links."Link ID" + 1
        else
            Entryno := 1;
        Links2.Init();
        Links2."Link ID" := Entryno;
        Links2.Type := Links2.Type::Link;
        Links2."Record ID" := ItemRec.RecordId;
        Links2.URL1 := apiLink;
        Links2.Description := APItxt;
        Links2.Created := CurrentDateTime;
        Links2."User ID" := UserId;
        Links2.Company := CompanyName;

        if Links2.Insert() then
            exit(ReturnTxt)
        else
            exit(GetLastErrorText());

    end;

    var
        ItemRec: Record Item;
        Links: Record 2000000068;
        Links2: Record 2000000068;

        Entryno: Integer;
        APItxt: Label 'Technical document';
        ReturnTxt: Label 'Links Succesfully Updated';
        AlreadyTxt: Label 'Link Already Exist';
}
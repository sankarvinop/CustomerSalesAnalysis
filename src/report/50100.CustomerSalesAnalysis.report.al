report 50100 "NMX_Customer Sales Analysis"
{
    ApplicationArea = All;
    Caption = 'Customer Analysis';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Excel;
    ExcelLayout = 'Src\ExcelLayout\50100_Customer Sales Analysis.xlsx';
    dataset
    {
        dataitem(Customer; Customer)
        {
            column(No; "No.")
            {
            }
            column(Name; Name)
            {
            }
            column(Address; Address)
            {
            }
            column(Address2; "Address 2")
            {
            }
            column(City; City)
            {
            }
            column(SalespersonCode; "Salesperson Code")
            {
            }
            column(Customer_Posting_Group; "Customer Posting Group")
            {

            }
            column(Country_Region_Code; "Country/Region Code")
            {
            }

            dataitem(Years; Integer)
            {
                DataItemTableView = sorting(Number);
                dataitem(Months; Integer)
                {
                    DataItemTableView = sorting(Number);
                    column(Period; CalcDate('CM', DMY2Date(1, Months.Number, TempCYYear)))
                    {


                    }

                    column(Sales; Customer."Sales (LCY)")
                    {

                    }
                    trigger OnPreDataItem()
                    begin
                        setRange(Number, 1, 12);
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        Customer.SetFilter("Date Filter", '%1..%2', DMY2Date(1, Months.Number, TempCYYear), CalcDate('CM', DMY2Date(1, Months.Number, TempCYYear)));
                        Customer.CalcFields("Sales (LCY)");
                    end;
                }
                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, NoOfYears);
                end;

                trigger OnAfterGetRecord()
                begin
                    if Years.Number = 1 then
                        TempCYYear := CYYear
                    else
                        TempCYYear := CYYear - Years.Number + 1;
                end;

            }
        }


    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Filter)
                {
                    Caption = 'Filter';
                    field(NoOfYears; NoOfYears)
                    {
                        ApplicationArea = All;
                        Caption = 'No. of Years';
                    }
                    field(CYYear; CYYear)
                    {
                        Caption = 'Current Year';
                        ApplicationArea = All;
                    }

                }
            }

        }
        actions
        {
            area(processing)
            {
            }
        }
        trigger OnInit()
        begin
            NoOfYears := 2;
            CYYear := Date2DMY(Today, 3);
        end;

    }

    trigger OnPreReport()
    begin
        if NoOfYears < 1 then
            NoOfYears := 2;
        if CYYear < 1 then
            CYYear := Date2DMY(Today, 3);
    end;

    var
        NoOfYears: Integer;
        TempCYYear: Integer;
        CYYear: Integer;
}
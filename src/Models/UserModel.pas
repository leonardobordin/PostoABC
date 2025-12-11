unit UserModel;

interface

type
  TUser = class
  private
    FID: string;
    FName: string;
    FEmail: string;
    FPassword: string;
  public
    property ID: string read FID write FID;
    property Name: string read FName write FName;
    property Email: string read FEmail write FEmail;
    property Password: string read FPassword write FPassword;
  end;

implementation

end.

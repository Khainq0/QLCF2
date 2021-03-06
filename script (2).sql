USE [Quanliquancafe]
GO
/****** Object:  UserDefinedFunction [dbo].[TimkiemGanDung]    Script Date: 5/7/2021 12:45:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TimkiemGanDung] ( @strInput NVARCHAR(4000) ) RETURNS NVARCHAR(4000) AS BEGIN IF @strInput IS NULL RETURN @strInput IF @strInput = '' RETURN @strInput DECLARE @RT NVARCHAR(4000) DECLARE @SIGN_CHARS NCHAR(136) DECLARE @UNSIGN_CHARS NCHAR (136) SET @SIGN_CHARS = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệế ìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵý ĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍ ÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ' +NCHAR(272)+ NCHAR(208) SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeee iiiiiooooooooooooooouuuuuuuuuuyyyyy AADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIII OOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD' DECLARE @COUNTER int DECLARE @COUNTER1 int SET @COUNTER = 1 WHILE (@COUNTER <=LEN(@strInput)) BEGIN SET @COUNTER1 = 1 WHILE (@COUNTER1 <=LEN(@SIGN_CHARS)+1) BEGIN IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1,1)) = UNICODE(SUBSTRING(@strInput,@COUNTER ,1) ) BEGIN IF @COUNTER=1 SET @strInput = SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)-1) ELSE SET @strInput = SUBSTRING(@strInput, 1, @COUNTER-1) +SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)- @COUNTER) BREAK END SET @COUNTER1 = @COUNTER1 +1 END SET @COUNTER = @COUNTER +1 END SET @strInput = replace(@strInput,' ','-') RETURN @strInput END
GO
/****** Object:  Table [dbo].[Food]    Script Date: 5/7/2021 12:45:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Food](
	[FoodID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[CategoryID] [int] NOT NULL,
	[Price] [float] NOT NULL,
	[UserName] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FoodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Foods Above Average Price]    Script Date: 5/7/2021 12:45:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[Foods Above Average Price] as
select Name, Price
from Food
where Price > (select AVG(Price) from Food)
GO
/****** Object:  Table [dbo].[FoodCategory]    Script Date: 5/7/2021 12:45:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FoodCategory](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Foods Belong To Fruit Juice]    Script Date: 5/7/2021 12:45:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[Foods Belong To Fruit Juice] as
select Food.Name
from Food, FoodCategory
where Food.CategoryID = FoodCategory.CategoryID 
and FoodCategory.Name = N'Nước ép trái cây'
GO
/****** Object:  Table [dbo].[Bill]    Script Date: 5/7/2021 12:45:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bill](
	[BillID] [int] IDENTITY(1,1) NOT NULL,
	[DateCheckIn] [datetime] NULL,
	[DateCheckOut] [datetime] NULL,
	[TableID] [int] NOT NULL,
	[UserName] [varchar](100) NOT NULL,
	[Status] [int] NULL,
	[Discount] [int] NULL,
	[totalPrice] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[BillID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BillInfo]    Script Date: 5/7/2021 12:45:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BillInfo](
	[FoodID] [int] NOT NULL,
	[BillID] [int] NOT NULL,
	[Count] [int] NOT NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_BillInfo] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FoodTable]    Script Date: 5/7/2021 12:45:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FoodTable](
	[TableID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[status] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TableID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Staff]    Script Date: 5/7/2021 12:45:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Staff](
	[UserName] [varchar](100) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[PassWord] [varchar](100) NOT NULL,
	[isManager] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Bill] ON 

INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (1385, CAST(N'2021-05-01T14:33:14.540' AS DateTime), CAST(N'2021-05-01T14:33:32.750' AS DateTime), 2, N'member2', 1, 0, 60000)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (1386, CAST(N'2021-05-01T14:33:43.700' AS DateTime), CAST(N'2021-05-01T14:35:17.257' AS DateTime), 4, N'member2', 1, 10, 198000)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (1387, CAST(N'2021-05-01T14:34:31.163' AS DateTime), CAST(N'2021-05-01T14:35:12.110' AS DateTime), 10, N'member2', 1, 10, 85500)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2385, CAST(N'2021-05-04T15:51:36.070' AS DateTime), CAST(N'2021-05-04T16:56:26.487' AS DateTime), 1, N'member2', 1, 0, 20000)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2386, CAST(N'2021-05-04T15:51:38.430' AS DateTime), CAST(N'2021-05-04T16:56:32.990' AS DateTime), 1016, N'member2', 1, 0, 20000)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2387, CAST(N'2021-05-04T15:51:40.083' AS DateTime), CAST(N'2021-05-04T16:56:35.030' AS DateTime), 6, N'member2', 1, 0, 20000)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2388, CAST(N'2021-05-04T15:51:42.453' AS DateTime), CAST(N'2021-05-04T16:56:31.003' AS DateTime), 10, N'member2', 1, 0, 20000)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2389, CAST(N'2021-05-04T15:51:43.670' AS DateTime), CAST(N'2021-05-04T16:56:28.603' AS DateTime), 5, N'member2', 1, 0, 20000)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2390, CAST(N'2021-05-04T16:56:21.590' AS DateTime), CAST(N'2021-05-04T16:56:23.767' AS DateTime), 7, N'member2', 1, 0, 60000)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2391, CAST(N'2021-05-04T17:27:18.027' AS DateTime), CAST(N'2021-05-04T17:52:41.340' AS DateTime), 1, N'member2', 1, 0, 90000)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2392, CAST(N'2021-05-04T22:08:58.410' AS DateTime), CAST(N'2021-05-04T22:10:50.397' AS DateTime), 1018, N'member2', 1, 0, 55000)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2393, CAST(N'2021-05-04T22:11:40.903' AS DateTime), NULL, 10, N'member2', 1, 0, NULL)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2394, CAST(N'2021-05-04T22:11:59.820' AS DateTime), CAST(N'2021-05-04T22:18:12.190' AS DateTime), 10, N'member2', 1, 0, 0)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2395, CAST(N'2021-05-04T22:26:22.580' AS DateTime), CAST(N'2021-05-04T22:26:26.090' AS DateTime), 4, N'member2', 1, 0, 90000)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2396, CAST(N'2021-05-04T22:26:28.197' AS DateTime), CAST(N'2021-05-04T22:48:08.867' AS DateTime), 8, N'member2', 1, 0, 85000)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2397, CAST(N'2021-05-04T22:26:39.990' AS DateTime), CAST(N'2021-05-04T22:48:13.127' AS DateTime), 1017, N'member2', 1, 0, 60000)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2398, CAST(N'2021-05-04T22:27:06.930' AS DateTime), CAST(N'2021-05-04T22:48:10.950' AS DateTime), 6, N'member2', 1, 0, 110000)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2400, CAST(N'2021-05-05T00:19:30.250' AS DateTime), NULL, 1016, N'member2', 1, 0, NULL)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2401, CAST(N'2021-05-05T00:20:53.797' AS DateTime), NULL, 9, N'member2', 1, 0, NULL)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2402, CAST(N'2021-05-05T01:21:08.690' AS DateTime), CAST(N'2021-05-05T02:39:08.623' AS DateTime), 8, N'member2', 1, 0, 90000)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2403, CAST(N'2021-05-05T02:39:42.030' AS DateTime), NULL, 1017, N'member2', 1, 0, NULL)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2404, CAST(N'2021-05-05T15:40:17.057' AS DateTime), CAST(N'2021-05-07T00:29:38.213' AS DateTime), 2, N'member2', 1, 0, 60000)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2405, CAST(N'2021-05-05T15:40:19.867' AS DateTime), CAST(N'2021-05-07T00:29:40.643' AS DateTime), 10, N'member2', 1, 0, 95000)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2406, CAST(N'2021-05-07T00:29:06.890' AS DateTime), CAST(N'2021-05-07T00:29:09.933' AS DateTime), 7, N'member2', 1, 0, 20000)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2407, CAST(N'2021-05-07T00:29:15.257' AS DateTime), CAST(N'2021-05-07T01:30:08.220' AS DateTime), 7, N'member2', 1, 0, 40000)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2408, CAST(N'2021-05-07T00:29:23.110' AS DateTime), CAST(N'2021-05-07T01:30:10.170' AS DateTime), 1017, N'member2', 1, 0, 130000)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2412, CAST(N'2021-05-07T01:42:24.580' AS DateTime), CAST(N'2021-05-07T01:42:37.417' AS DateTime), 1018, N'member1', 1, 0, 40000)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2413, CAST(N'2021-05-07T01:43:03.077' AS DateTime), CAST(N'2021-05-07T02:25:35.607' AS DateTime), 1017, N'member2', 1, 0, 40000)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2414, CAST(N'2021-05-07T01:45:24.020' AS DateTime), NULL, 1016, N'member2', 1, 0, NULL)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2415, CAST(N'2021-05-07T02:25:52.893' AS DateTime), CAST(N'2021-05-07T02:25:55.367' AS DateTime), 1017, N'member2', 1, 0, 40000)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2416, CAST(N'2021-05-07T02:26:02.803' AS DateTime), CAST(N'2021-05-07T02:26:05.113' AS DateTime), 1016, N'member2', 1, 0, 40000)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2417, CAST(N'2021-05-07T02:26:56.523' AS DateTime), CAST(N'2021-05-07T02:30:56.127' AS DateTime), 1016, N'member2', 1, 0, 20000)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2422, CAST(N'2021-05-07T11:03:19.547' AS DateTime), CAST(N'2021-05-07T12:20:44.927' AS DateTime), 4, N'member2', 1, 0, 40000)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2423, CAST(N'2021-05-07T11:03:23.507' AS DateTime), CAST(N'2021-05-07T12:20:47.220' AS DateTime), 7, N'member2', 1, 0, 90000)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2424, CAST(N'2021-05-07T12:20:49.333' AS DateTime), CAST(N'2021-05-07T12:20:51.353' AS DateTime), 1, N'member2', 1, 0, 60000)
INSERT [dbo].[Bill] ([BillID], [DateCheckIn], [DateCheckOut], [TableID], [UserName], [Status], [Discount], [totalPrice]) VALUES (2425, CAST(N'2021-05-07T12:35:25.193' AS DateTime), NULL, 1, N'member2', 0, 0, NULL)
SET IDENTITY_INSERT [dbo].[Bill] OFF
GO
SET IDENTITY_INSERT [dbo].[BillInfo] ON 

INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (14, 1385, 2, 370)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (28, 1385, 1, 371)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (53, 1386, 1, 372)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (54, 1386, 1, 373)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (68, 1386, 1, 374)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (49, 1386, 1, 375)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (44, 1386, 1, 376)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (14, 1387, 1, 377)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (72, 1387, 1, 378)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (19, 1387, 1, 379)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (32, 1387, 1, 380)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (32, 1386, 1, 381)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (14, 2385, 1, 1347)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (14, 2386, 1, 1348)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (14, 2387, 1, 1349)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (14, 2388, 1, 1350)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (14, 2389, 1, 1351)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (14, 2390, 3, 1352)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (43, 2391, 1, 1353)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (69, 2391, 1, 1354)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (15, 2392, 1, 1355)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (57, 2392, 1, 1356)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (43, 2394, 1, 1360)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (37, 2394, 1, 1361)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (60, 2395, 2, 1363)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (60, 2396, 1, 1364)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (65, 2396, 1, 1365)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (63, 2397, 1, 1366)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (46, 2397, 1, 1367)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (33, 2398, 1, 1368)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (70, 2398, 1, 1369)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (50, 2398, 1, 1370)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (14, 2402, 1, 1374)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (32, 2402, 1, 1376)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (60, 2402, 1, 1377)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (14, 2404, 3, 1379)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (14, 2405, 3, 1380)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (47, 2405, 1, 1381)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (14, 2406, 1, 1382)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (64, 2407, 1, 1383)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (67, 2408, 1, 1384)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (19, 2408, 1, 1385)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (66, 2408, 1, 1386)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (14, 2412, 1, 1387)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (28, 2412, 1, 1388)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (64, 2413, 1, 1389)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (14, 2415, 2, 1391)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (14, 2416, 2, 1392)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (14, 2417, 1, 1394)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (14, 2422, 2, 1399)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (61, 2423, 1, 1400)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (67, 2423, 1, 1401)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (14, 2424, 3, 1402)
INSERT [dbo].[BillInfo] ([FoodID], [BillID], [Count], [ID]) VALUES (14, 2425, 4, 1403)
SET IDENTITY_INSERT [dbo].[BillInfo] OFF
GO
SET IDENTITY_INSERT [dbo].[Food] ON 

INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (14, N'Cafe đen đá', 1, 20000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (15, N'Cafe nâu đá', 1, 20000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (16, N'Cafe đen nóng', 1, 20000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (17, N'Cafe nâu nóng', 1, 20000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (19, N'Bạc sỉu đá', 1, 35000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (20, N'Bạc sỉu nóng', 1, 35000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (21, N'Cacao sữa đá', 1, 30000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (22, N'Cacao sữa nóng', 1, 30000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (23, N'Cafe cốt dừa', 1, 35000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (24, N'Cafe kem tươi', 1, 40000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (25, N'Nước suối', 2, 10000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (26, N'Lipton chanh đá', 2, 15000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (27, N'Lipton chanh nóng', 2, 15000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (28, N'Lipton sữa đá', 2, 20000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (29, N'Lipton sữa nóng', 2, 20000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (31, N'Lipton chanh mật ong nóng', 2, 25000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (32, N'Lipton chanh mật ong đá', 2, 25000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (33, N'Trà đào đá', 2, 15000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (34, N'Trà đào nóng', 2, 15000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (35, N'Trà bạc hà đá', 2, 15000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (36, N'Trà bạc hà nóng', 2, 15000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (37, N'Trà gừng mật ong', 2, 25000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (38, N'Trà hoa cúc đá', 2, 20000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (40, N'Trà hoa cúc nóng', 2, 20000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (41, N'Matcha sữa đá', 2, 20000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (42, N'Matcha sữa nóng', 2, 20000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (43, N'Nước ép cà rốt', 3, 30000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (44, N'Nước cam ép', 3, 35000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (45, N'Nước ép dứa', 3, 35000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (46, N'Nước mía', 3, 25000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (47, N'Nước ép ổi', 3, 35000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (48, N'Nước ép bưởi', 3, 30000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (49, N'Nước ép dưa hấu', 3, 35000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (50, N'Nước ép táo', 3, 35000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (51, N'Nước ép nho', 3, 40000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (52, N'Nước dừa nguyên chất', 3, 35000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (53, N'Sinh tố bơ', 4, 35000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (54, N'Sinh tố mãng cầu', 4, 40000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (55, N'Sinh tố nho', 4, 40000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (56, N'Sinh tố chuối', 4, 35000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (57, N'Sinh tố dưa hấu', 4, 35000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (58, N'Sinh tố dứa', 4, 35000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (59, N'Sinh tố xoài', 4, 35000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (60, N'Sinh tố bơ việt quật', 4, 45000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (61, N'Hồng trà sữa chân trâu', 5, 40000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (63, N'Trà sữa Olong', 5, 35000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (64, N'Trà sữa caramel', 5, 40000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (65, N'Trà sữa kem cheese', 5, 40000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (66, N'Sữa tươi chân trâu đường đen', 5, 45000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (67, N'Bánh flan', 6, 50000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (68, N'Bánh cookies', 6, 50000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (69, N'Mousse cake', 6, 60000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (70, N'Nama chocolate', 6, 60000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (71, N'Bim bim', 7, 10000, N'member0')
INSERT [dbo].[Food] ([FoodID], [Name], [CategoryID], [Price], [UserName]) VALUES (72, N'Hướng dương', 7, 15000, N'member0')
SET IDENTITY_INSERT [dbo].[Food] OFF
GO
SET IDENTITY_INSERT [dbo].[FoodCategory] ON 

INSERT [dbo].[FoodCategory] ([CategoryID], [Name]) VALUES (1, N'Cafe')
INSERT [dbo].[FoodCategory] ([CategoryID], [Name]) VALUES (2, N'Đồ uống')
INSERT [dbo].[FoodCategory] ([CategoryID], [Name]) VALUES (3, N'Nước ép trái cây')
INSERT [dbo].[FoodCategory] ([CategoryID], [Name]) VALUES (4, N'Sinh tố')
INSERT [dbo].[FoodCategory] ([CategoryID], [Name]) VALUES (5, N'Trà sữa')
INSERT [dbo].[FoodCategory] ([CategoryID], [Name]) VALUES (6, N'Bánh ngọt')
INSERT [dbo].[FoodCategory] ([CategoryID], [Name]) VALUES (7, N'Đồ ăn vặt')
SET IDENTITY_INSERT [dbo].[FoodCategory] OFF
GO
SET IDENTITY_INSERT [dbo].[FoodTable] ON 

INSERT [dbo].[FoodTable] ([TableID], [Name], [status]) VALUES (1, N'Bàn 1', N'Đã có người')
INSERT [dbo].[FoodTable] ([TableID], [Name], [status]) VALUES (2, N'Bàn 2', N'Trống')
INSERT [dbo].[FoodTable] ([TableID], [Name], [status]) VALUES (4, N'Bàn 3', N'Trống')
INSERT [dbo].[FoodTable] ([TableID], [Name], [status]) VALUES (5, N'Bàn 4', N'Trống')
INSERT [dbo].[FoodTable] ([TableID], [Name], [status]) VALUES (6, N'Bàn 5', N'Trống')
INSERT [dbo].[FoodTable] ([TableID], [Name], [status]) VALUES (7, N'Bàn 6', N'Trống')
INSERT [dbo].[FoodTable] ([TableID], [Name], [status]) VALUES (8, N'Bàn 7', N'Trống')
INSERT [dbo].[FoodTable] ([TableID], [Name], [status]) VALUES (9, N'Bàn 8', N'Trống')
INSERT [dbo].[FoodTable] ([TableID], [Name], [status]) VALUES (10, N'Bàn 9', N'Trống')
INSERT [dbo].[FoodTable] ([TableID], [Name], [status]) VALUES (1016, N'Bàn 10', N'Trống')
INSERT [dbo].[FoodTable] ([TableID], [Name], [status]) VALUES (1017, N'Bàn 11', N'Trống')
INSERT [dbo].[FoodTable] ([TableID], [Name], [status]) VALUES (1018, N'Bàn 12', N'Trống')
SET IDENTITY_INSERT [dbo].[FoodTable] OFF
GO
INSERT [dbo].[Staff] ([UserName], [Name], [PassWord], [isManager]) VALUES (N'an', N'Thầy An', N'1111', 1)
INSERT [dbo].[Staff] ([UserName], [Name], [PassWord], [isManager]) VALUES (N'huong', N'Cô Hường', N'1111', 1)
INSERT [dbo].[Staff] ([UserName], [Name], [PassWord], [isManager]) VALUES (N'member0', N'Hường', N'1111', 1)
INSERT [dbo].[Staff] ([UserName], [Name], [PassWord], [isManager]) VALUES (N'member1', N'Đô', N'1234', 0)
INSERT [dbo].[Staff] ([UserName], [Name], [PassWord], [isManager]) VALUES (N'member2', N'Nghĩa', N'1234', 0)
INSERT [dbo].[Staff] ([UserName], [Name], [PassWord], [isManager]) VALUES (N'member3', N'Khải', N'1234', 0)
INSERT [dbo].[Staff] ([UserName], [Name], [PassWord], [isManager]) VALUES (N'member4', N'Hiếu', N'1234', 0)
INSERT [dbo].[Staff] ([UserName], [Name], [PassWord], [isManager]) VALUES (N'member5', N'Phương', N'1234', 0)
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [FoodName_DuyNhat]    Script Date: 5/7/2021 12:45:50 PM ******/
ALTER TABLE [dbo].[Food] ADD  CONSTRAINT [FoodName_DuyNhat] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Food] ADD  DEFAULT (N'Chưa đặt tên') FOR [Name]
GO
ALTER TABLE [dbo].[FoodCategory] ADD  DEFAULT (N'Loại món ăn chưa đặt tên') FOR [Name]
GO
ALTER TABLE [dbo].[FoodTable] ADD  DEFAULT (N'Bàn chưa đặt tên') FOR [Name]
GO
ALTER TABLE [dbo].[FoodTable] ADD  DEFAULT (N'Trống') FOR [status]
GO
ALTER TABLE [dbo].[Staff] ADD  DEFAULT ((0)) FOR [isManager]
GO
ALTER TABLE [dbo].[Bill]  WITH CHECK ADD  CONSTRAINT [Bill_Fk1] FOREIGN KEY([TableID])
REFERENCES [dbo].[FoodTable] ([TableID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Bill] CHECK CONSTRAINT [Bill_Fk1]
GO
ALTER TABLE [dbo].[Bill]  WITH CHECK ADD  CONSTRAINT [Bill_Fk2] FOREIGN KEY([UserName])
REFERENCES [dbo].[Staff] ([UserName])
GO
ALTER TABLE [dbo].[Bill] CHECK CONSTRAINT [Bill_Fk2]
GO
ALTER TABLE [dbo].[BillInfo]  WITH CHECK ADD  CONSTRAINT [FK_BillInfo_Bill] FOREIGN KEY([BillID])
REFERENCES [dbo].[Bill] ([BillID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BillInfo] CHECK CONSTRAINT [FK_BillInfo_Bill]
GO
ALTER TABLE [dbo].[BillInfo]  WITH CHECK ADD  CONSTRAINT [FK_BillInfo_Food] FOREIGN KEY([FoodID])
REFERENCES [dbo].[Food] ([FoodID])
GO
ALTER TABLE [dbo].[BillInfo] CHECK CONSTRAINT [FK_BillInfo_Food]
GO
ALTER TABLE [dbo].[Food]  WITH CHECK ADD  CONSTRAINT [Food_Fk1] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[FoodCategory] ([CategoryID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Food] CHECK CONSTRAINT [Food_Fk1]
GO
ALTER TABLE [dbo].[Food]  WITH CHECK ADD  CONSTRAINT [Food_Fk2] FOREIGN KEY([UserName])
REFERENCES [dbo].[Staff] ([UserName])
GO
ALTER TABLE [dbo].[Food] CHECK CONSTRAINT [Food_Fk2]
GO
/****** Object:  StoredProcedure [dbo].[usp_AddTable]    Script Date: 5/7/2021 12:45:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_AddTable]
(
	@tableID INT,
	@name NVARCHAR(100),
	@status NVARCHAR(100)
)
AS
BEGIN
	INSERT INTO FoodTable( TableID, Name, status) VALUES (@tableID , @name , @status);
END
GO
/****** Object:  StoredProcedure [dbo].[usp_DeleteTable]    Script Date: 5/7/2021 12:45:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Xóa
CREATE PROCEDURE [dbo].[usp_DeleteTable]
(
	@tableID INT
)
AS
BEGIN
	DELETE FROM FoodTable
	WHERE TableID = @tableID
END
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAccountByUserName]    Script Date: 5/7/2021 12:45:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[usp_GetAccountByUserName]
	@userName nvarchar(50)
as
begin
	Select UserName as N'Tên tài khoản', PassWord as N'Mật khẩu'from Staff 
	where UserName = @userName
end
GO
/****** Object:  StoredProcedure [dbo].[USP_GetListBillByDate]    Script Date: 5/7/2021 12:45:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GetListBillByDate]
	@CheckIn date, @CheckOut date
AS
BEGIN
	SELECT t.Name AS [Tên bàn], b.DateCheckIn [Thời gian đến], b.DateCheckOut [Thời gian đi], b.Discount [Giảm giá(%)], b.totalPrice [Tổng tiền(VND)]
	FROM dbo.Bill AS b, dbo.FoodTable AS t
	WHERE b.DateCheckIn >= @CheckIn AND b.DateCheckOut <= @CheckOut AND b.Status = 1
	AND t.TableID = b.TableID
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetTableList]    Script Date: 5/7/2021 12:45:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GetTableList]
AS
BEGIN
	SELECT * FROM FoodTable
END
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertBill]    Script Date: 5/7/2021 12:45:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[USP_InsertBill]
	@TableID INT,
	@UserName NVARCHAR(100)
AS
BEGIN
	INSERT Bill
	(
		DateCheckIn,
		DateCheckOut,
		TableID,
		UserName,
		Status,
		Discount
	)
	VALUES
	(
		GETDATE(),
		NULL,
		@TableID,
		@UserName,
		0,
		0
	)
END
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertBillInfo]    Script Date: 5/7/2021 12:45:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_InsertBillInfo]
	@FoodID INT, @BillID INT, @Count INT
AS
BEGIN

	DECLARE @isExitBillInfo INT
	DECLARE @FoodCount INT = 1

	SELECT @isExitBillInfo = b.ID, @FoodCount = b.Count 
	FROM BillInfo as b
	WHERE b.BillID = @BillID AND b.FoodID = @FoodID

	IF (@isExitBillInfo > 0)
		BEGIN
			DECLARE @newCount INT = @FoodCount + @Count
			
			IF (@newCount > 0)
				UPDATE BillInfo SET Count = @FoodCount + @Count WHERE FoodID = @FoodID AND BillID = @BillID
			ELSE
				DELETE BillInfo WHERE BillID = @BillID AND FoodID = @FoodID
		END
	ELSE
		BEGIN
			INSERT BillInfo
			(
				FoodID,
				BillID,
				Count
			)
			VALUES
			(
				@FoodID,
				@BillID,
				@Count
			)
		END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Login]    Script Date: 5/7/2021 12:45:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_Login]
	@userName varchar(100),
	@password varchar(100)
AS
BEGIN
	SELECT * FROM Staff WHERE UserName = @userName AND PassWord = @password
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SoSanhTenFood]    Script Date: 5/7/2021 12:45:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SoSanhTenFood]
	@name NVARCHAR(50)
AS
BEGIN
	SELECT Name FROM dbo.Food WHERE Name = @name
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SwitchTable]    Script Date: 5/7/2021 12:45:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SwitchTable]
	@tableID1 INT, @tableID2 INT , @userName NVARCHAR(100)
AS
BEGIN
	DECLARE @FirstBillID INT
	DECLARE @SecondBillID INT

	declare @isFirstTableEmpty INT = 1
	declare @isSecondTableEmpty INT = 1

	select @FirstBillID = BillID from Bill where TableID = @tableID1 and Status = 0
	select @SecondBillID = billID from Bill where TableID = @tableID2 and Status = 0

	if (@FirstBillID is null)
	begin
		insert into Bill
			(
				DateCheckIn,
				DateCheckOut,
				TableID,
				UserName,
				Status,
				Discount
			)
		values
			(
				GETDATE(),
				null,
				@tableID1,
				@userName,
				0,
				0
			)
		select @FirstBillID = MAX(BillID) from Bill where TableID = @tableID1 and Status = 0
	end

	select @isFirstTableEmpty = COUNT(*) from BillInfo where BillID = @FirstBillID

	if (@SecondBillID is null)
	begin
		insert into Bill
			(
				DateCheckIn,
				DateCheckOut,
				TableID,
				UserName,
				Status,
				Discount
			)
		values
			(
				GETDATE(),
				null,
				@tableID2,
				@userName,
				0,
				0
			)
		select @SecondBillID = MAX(BillID) from Bill where TableID = @tableID2 and Status = 0
	end

	DECLARE @status1 NVARCHAR(100)
	SELECT @status1 = status FROM dbo.FoodTable WHERE TableID = @tableID1

	DECLARE @status2 NVARCHAR(100)
	SELECT @status2 = status FROM dbo.FoodTable WHERE TableID = @tableID2

	select @isSecondTableEmpty = COUNT(*) from BillInfo where BillID = @SecondBillID

	SELECT id INTO IDBillInfoTable from BillINfo where BillID = @SecondBillID

	update BillInfo	set BillID = @SecondBillID where BillID = @FirstBillID

	update BillInfo set BillID = @FirstBillID where ID in (select * from IDBillInfoTable)

	drop table IDBillInfoTable

	if (@isFirstTableEmpty = 0)
		update FoodTable set status = N'Trống' where TableID = @tableID2
	if (@isSecondTableEmpty = 0)
		update FoodTable set status = N'Trống' where TableID = @tableID1

	IF (@status1 = N'Đã có người' AND @status2 = N'Trống')
		DELETE FROM dbo.Bill WHERE BillID = @FirstBillID
	IF (@status1 = N'Trống' AND @status2 = N'Đã có người')
		DELETE dbo.Bill WHERE BillID = @SecondBillID
	IF (@status1 = N'Trống' AND @status2 = N'Trống')
	BEGIN
		DELETE dbo.Bill WHERE BillID = @FirstBillID
		DELETE dbo.Bill WHERE BillID = @SecondBillID
	END
END
GO
/****** Object:  StoredProcedure [dbo].[usp_UpadteTable]    Script Date: 5/7/2021 12:45:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpadteTable]
(
	@name NVARCHAR(100),
	@status NVARCHAR(100)
)
AS
BEGIN
	UPDATE FoodTable
	SET 
		Name = @name,
		status = @status
END
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateAccount]    Script Date: 5/7/2021 12:45:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_UpdateAccount]
@userName NVARCHAR(50), @name NVARCHAR(50), @password NVARCHAR(50), @newPassword NVARCHAR(50)
AS
BEGIN
	DECLARE @isRightPassword INT = 0

	SELECT @isRightPassword = COUNT(*) FROM dbo.Staff WHERE @userName = UserName AND @password = PassWord
	
	IF (@isRightPassword = 1)
	BEGIN
		IF (@newPassword = NULL OR @newPassword = '')
			BEGIN
				UPDATE dbo.Staff SET Name = @name WHERE UserName = @userName
			END
		ELSE
			UPDATE dbo.Staff SET Name = @name, PassWord = @newPassword WHERE UserName = @userName
	END

END
GO
/****** Object:  Trigger [dbo].[UTG_UpdateBill]    Script Date: 5/7/2021 12:45:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[UTG_UpdateBill]
ON [dbo].[Bill] FOR UPDATE
AS
BEGIN
	DECLARE @BillID INT

	SELECT @BillID = BillID FROM inserted

	DECLARE @TableID INT

	SELECT @TableID = TableID FROM Bill	WHERE BillID = @BillID

	DECLARE @Count INT = 0

	SELECT @Count = COUNT(*) FROM Bill WHERE TableID = @TableID AND Status = 0

	IF (@Count = 0)
		BEGIN
			UPDATE FoodTable SET status = N'Trống' WHERE TableID = @TableID
		END
	ELSE
		BEGIN
			UPDATE dbo.FoodTable SET status = N'Đã có người' WHERE TableID = @TableID
		END
END
GO
ALTER TABLE [dbo].[Bill] ENABLE TRIGGER [UTG_UpdateBill]
GO
/****** Object:  Trigger [dbo].[UTG_DeleteBillInfo]    Script Date: 5/7/2021 12:45:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[UTG_DeleteBillInfo]
ON [dbo].[BillInfo] FOR DELETE
AS
BEGIN
	DECLARE @BillInfoID INT
	DECLARE @BillID INT
	SELECT @BillInfoID = id, @BillID = Deleted.BillID FROM Deleted

	DECLARE @TableID INT
	SELECT @TableID = TableID FROM dbo.Bill WHERE @BillID = BillID

	DECLARE @count INT
	SELECT @count = COUNT(*) FROM dbo.BillInfo AS bi, dbo.Bill AS b 
	WHERE b.BillID = bi.BillID AND b.BillID = @BillID AND b.Status = 0

	IF (@count = 0)
		UPDATE dbo.FoodTable SET status = N'Trống' WHERE TableID = @TableID
END
GO
ALTER TABLE [dbo].[BillInfo] ENABLE TRIGGER [UTG_DeleteBillInfo]
GO
/****** Object:  Trigger [dbo].[UTG_UpdateBillInfo]    Script Date: 5/7/2021 12:45:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[UTG_UpdateBillInfo]
ON [dbo].[BillInfo] FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @BillID INT

	SELECT @BillID = BillID FROM inserted

	DECLARE @TableID INT

	SELECT @TableID = TableID FROM Bill	WHERE BillID = @BillID AND Status = 0

	UPDATE FoodTable SET status = N'Đã có người' WHERE TableID = @TableID
END
GO
ALTER TABLE [dbo].[BillInfo] ENABLE TRIGGER [UTG_UpdateBillInfo]
GO
/****** Object:  Trigger [dbo].[UTG_DeleteFood]    Script Date: 5/7/2021 12:45:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[UTG_DeleteFood]
ON [dbo].[Food] FOR DELETE
AS
BEGIN
	DELETE FROM dbo.Bill WHERE DateCheckOut = NULL
END
GO
ALTER TABLE [dbo].[Food] ENABLE TRIGGER [UTG_DeleteFood]
GO

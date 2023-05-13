-- Do not alter the following line
module Assignment2 (transaction_to_string, trade_report_list, stock_test, get_trades, trade_report, update_money, profit, profit_report, complex_profit_report) where


type Transaction = (Char, Int, Int, String, Int)

test_log :: [Transaction]
test_log = [('B', 100, 1104,  "VTI",  1),
            ('B', 200,   36, "ONEQ",  3),
            ('B',  50, 1223,  "VTI",  5),
            ('S', 150, 1240,  "VTI",  9),
            ('B', 100,  229, "IWRD", 10),
            ('S', 200,   32, "ONEQ", 11), 
            ('S', 100,  210, "IWRD", 12)
            ]


-- Part A

transaction_to_string :: Transaction -> String
transaction_to_string (action, units, price, stock, day) =
 var ++ show units ++ " units of " ++ stock ++ " for " ++ show price ++ " pounds each on day " ++ show day
 where var 
        | action == 'B' = "Bought "
        | action == 'S' = "Sold "


trade_report_list :: [Transaction] -> [String]
trade_report_list transaction_log = map transaction_to_string transaction_log


stock_test :: String -> Transaction -> Bool
stock_test query (_, _, _, stock, _)
 | stock == query = True
 | otherwise      = False


get_trades :: String -> [Transaction] -> [Transaction]
get_trades stock transaction_log = filter (stock_test stock) transaction_log


trade_report :: String -> [Transaction] -> String
trade_report stock transaction_log = unlines (trade_report_list (get_trades stock transaction_log))


-- Part B

update_money :: Transaction -> Int -> Int
update_money (action, units, price, _, _) current_money
 | action == 'B' = current_money - units * price
 | action == 'S' = current_money + units * price


profit :: [Transaction] -> String -> Int
profit transaction_log stock = foldr (\ transaction -> update_money transaction) 0 (get_trades stock transaction_log)


profit_report :: [String] -> [Transaction] -> String
profit_report stock_list transaction_log = foldr (\stock -> (++) (stock ++ ": " ++ show (profit transaction_log stock) ++ "\n")) [] stock_list


-- Part C

test_str_log = "BUY 100 VTI 1\nBUY 200 ONEQ 3\nBUY 50 VTI 5\nSELL 150 VTI 9\nBUY 100 IWRD 10\nSELL 200 ONEQ 11\nSELL 100 IWRD 12\n"


type Prices = [(String, [Int])]

test_prices :: Prices
test_prices = [
                ("VTI", [1689, 1785, 1772, 1765, 1739, 1725, 1615, 1683, 1655, 1725, 1703, 1726, 1725, 1742, 1707, 1688, 1697, 1688, 1675]),
                ("ONEQ", [201, 203, 199, 199, 193, 189, 189, 183, 185, 190, 186, 182, 186, 182, 182, 186, 183, 179, 178]),
                ("IWRD", [207, 211, 213, 221, 221, 222, 221, 218, 226, 234, 229, 229, 228, 222, 218, 223, 222, 218, 214])
              ]


 -- HELPER FUNCTIONS FOR COMPLEX PROFILE REPORT FUNCTION

tail_words :: String -> String
tail_words (x : xs)
 | x == ' ' || x == '\n' = xs
 | otherwise             = tail_words (xs)


head_word :: String -> String
head_word (x : xs)
 | x == ' ' || x == '\n' = []
 | otherwise             = x : head_word xs


get_stock_prices :: String -> Prices -> [Int]
get_stock_prices stock prices
 | fst (head prices) == stock = snd $ head prices
 | otherwise                  = get_stock_prices stock (tail prices)


get_price :: String -> Prices -> Int -> Int
get_price stock prices day = get_stock_prices stock prices !! (day - 1)


complex_get_trades :: String -> String -> Prices -> [Transaction]
complex_get_trades stock transaction_log prices
 | transaction_log == []                = []
 | (h $ t $ t transaction_log) /= stock = complex_get_trades stock (t $ t $ t $ t transaction_log) prices
 | otherwise                            =
    let action =        head          transaction_log
        units  = read $ h $ t         transaction_log
        stock  =        h $ t $ t     transaction_log
        day    = read $ h $ t $ t $ t transaction_log
        price  =        get_price stock prices day
    in [(action, units, price, stock, day)] ++ complex_get_trades stock (t $ t $ t $ t transaction_log) prices
 where
        h      = head_word
        t      = tail_words


complex_get_stock_list :: Prices -> [String]
complex_get_stock_list (x : xs)
 | xs == []  = [fst x]
 | otherwise = fst x : complex_get_stock_list xs


 -- COMPLEX PROFILE REPORT FUNCTION

complex_profit_report :: String -> Prices -> String
complex_profit_report "" _                   = []
complex_profit_report transaction_log prices = foldr (
 \stock -> (++) (
  stock ++ ": " ++ show (profit (complex_get_trades stock transaction_log prices) stock) ++ "\n")
 ) [] $ complex_get_stock_list prices

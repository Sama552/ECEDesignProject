using SerialPorts;
using PyPlot;
using FFTW

DIST = 0.019;       #Distance between the centres of the receivers, to be measured
FREQ = 40000;       #f0
THRESHOLD = 1.9e9;     #THRESHOLD of the main lobe, to be adjusted from real-world values
THRESHOLD1 = 2e8;
SAMPLES = 29000;
sampleSize = 29000   # How many samples we've taken to get full range
C = 343;            #speed o sound sonic
SMPL_RATE = 500000; #Sample rate
dt = 1/500000;
t_max = (SAMPLES/SMPL_RATE)-dt;
t = 0:dt:t_max;
RES = 1400

speed = 343     #Speed of sound in air
sample_rate = 500000   #Sample rate
dt = 1 / sample_rate     #sample spacing
# r_max = 10     #Maximum Range
# t_max = 2 * r_max / speed     #Time until wave returns from max range

#Create an array containing the time values of the samples
r = speed .* t / 2
r = r[1:sampleSize]

matched_filter = [1862.0, 1905.0, 1941.0, 1956.0,
    1945.0, 1917.0, 1875.0, 1833.0, 1796.0, 1775.0, 1777.0, 1801.0, 1836.0, 1876.0, 1914.0, 1942.0, 1948.0, 1929.0, 1904.0, 1871.0, 1834.0, 1801.0, 1784.0, 1785.0, 1807.0, 1843.0, 1884.0, 1917.0, 1939.0, 1942.0, 1923.0, 1888.0, 1849.0, 1813.0, 1787.0, 1784.0, 1800.0, 1830.0, 1868.0, 1905.0, 1931.0, 1943.0, 1935.0, 1904.0, 1868.0, 1833.0, 1805.0, 1789.0, 1787.0, 1804.0, 1834.0, 1873.0, 1912.0, 1936.0, 1945.0, 1930.0, 1893.0, 1853.0, 1821.0, 1795.0, 1781.0, 1790.0, 1814.0, 1849.0, 1888.0, 1918.0, 1935.0, 1940.0, 1921.0, 1884.0, 1842.0, 1809.0, 1788.0, 1781.0, 1794.0, 1822.0, 1862.0, 1905.0, 1935.0, 1946.0, 1938.0, 1909.0, 1867.0, 1833.0, 1807.0, 1789.0, 1790.0, 1810.0, 1845.0, 1884.0, 1915.0, 1935.0, 1936.0, 1922.0, 1894.0, 1853.0, 1813.0, 1786.0, 1774.0, 1785.0, 1814.0, 1850.0, 1891.0, 1925.0, 1945.0, 1942.0, 1918.0, 1878.0, 1830.0, 1794.0, 1778.0, 1784.0, 1805.0, 1836.0, 1875.0, 1909.0, 1934.0, 1942.0, 1932.0, 1904.0, 1865.0, 1820.0, 1788.0, 1775.0, 1781.0, 1807.0, 1843.0, 1886.0, 1922.0, 1944.0, 1950.0, 1936.0, 1904.0, 1859.0, 1815.0, 1785.0, 1773.0, 1786.0, 1817.0, 1859.0, 1899.0, 1926.0, 1942.0, 1939.0, 1918.0, 1881.0, 1839.0, 1802.0, 1779.0, 1779.0, 1800.0, 1837.0, 1879.0, 1916.0, 1944.0, 1952.0, 1942.0, 1910.0, 1867.0, 1819.0, 1784.0, 1768.0, 1775.0, 1804.0, 1837.0, 1882.0, 1923.0, 1948.0, 1958.0, 1946.0, 1907.0, 1857.0, 1813.0, 1778.0, 1767.0, 1780.0, 1814.0, 1861.0, 1909.0, 1946.0, 1964.0, 1957.0, 1928.0, 1883.0, 1830.0, 1790.0, 1762.0, 1759.0, 1780.0, 1825.0, 1871.0, 1917.0, 1948.0, 1958.0, 1946.0, 1911.0, 1863.0, 1819.0, 1783.0, 1764.0, 1766.0, 1796.0, 1839.0, 1885.0, 1929.0, 1957.0, 1958.0, 1937.0, 1892.0, 1841.0, 1799.0, 1766.0, 1760.0, 1775.0, 1814.0, 1864.0, 1916.0, 1956.0, 1973.0, 1963.0, 1930.0, 1881.0, 1828.0, 1782.0, 1757.0, 1761.0, 1789.0, 1835.0, 1885.0, 1926.0, 1958.0, 1967.0, 1951.0, 1909.0, 1857.0, 1809.0, 1774.0, 1754.0, 1766.0, 1799.0, 1853.0, 1905.0, 1944.0, 1966.0, 1967.0, 1944.0, 1896.0, 1838.0, 1789.0, 1756.0, 1749.0, 1771.0, 1814.0, 1870.0, 1924.0, 1958.0, 1973.0, 1959.0, 1919.0, 1866.0, 1811.0, 1766.0, 1745.0, 1755.0, 1793.0, 1847.0, 1906.0, 1949.0, 1968.0, 1966.0, 1942.0, 1894.0, 1837.0, 1787.0, 1752.0, 1747.0, 1770.0, 1813.0, 1865.0, 1921.0, 1960.0, 1970.0, 1961.0, 1929.0, 1878.0, 1823.0, 1777.0, 1752.0, 1753.0, 1782.0, 1833.0, 1889.0, 1938.0, 1969.0, 1973.0, 1950.0, 1906.0, 1850.0, 1798.0, 1763.0, 1755.0, 1771.0, 1809.0, 1860.0, 1915.0, 1957.0, 1976.0, 1964.0, 1929.0, 1877.0, 1826.0, 1783.0, 1758.0, 1754.0, 1781.0, 1823.0, 1879.0, 1930.0, 1968.0, 1979.0, 1960.0, 1921.0, 1867.0, 1809.0, 1768.0, 1747.0, 1756.0, 1789.0, 1843.0, 1906.0, 1959.0, 1986.0, 1983.0, 1947.0, 1894.0, 1835.0, 1785.0, 1753.0, 1746.0, 1766.0, 1813.0, 1872.0, 1931.0, 1970.0, 1984.0, 1969.0, 1925.0, 1872.0, 1820.0, 1781.0, 1759.0, 1759.0, 1789.0, 1838.0, 1896.0, 1944.0, 1976.0, 1987.0, 1964.0, 1911.0, 1850.0, 1797.0, 1758.0, 1744.0, 1763.0, 1807.0, 1865.0, 1922.0, 1964.0, 1983.0, 1975.0, 1939.0, 1877.0, 1819.0, 1770.0, 1743.0, 1741.0, 1770.0, 1823.0, 1882.0, 1936.0, 1969.0, 1978.0, 1961.0, 1918.0, 1857.0, 1802.0, 1766.0, 1750.0, 1762.0, 1797.0, 1846.0, 1902.0, 1950.0, 1982.0, 1986.0, 1958.0, 1905.0, 1839.0, 1785.0, 1749.0, 1742.0, 1763.0, 1806.0, 1865.0, 1926.0, 1968.0, 1985.0, 1971.0, 1930.0, 1876.0, 1818.0, 1774.0, 1741.0, 1745.0, 1783.0, 1837.0, 1896.0, 1945.0, 1975.0, 1979.0, 1954.0, 1910.0, 1852.0, 1803.0, 1765.0, 1746.0, 1758.0, 1798.0, 1853.0, 1913.0, 1957.0, 1985.0, 1981.0, 1948.0, 1893.0, 1830.0, 1781.0, 1747.0, 1737.0, 1761.0, 1819.0, 1884.0, 1940.0, 1978.0, 1988.0, 1967.0, 1920.0, 1860.0, 1799.0, 1756.0, 1735.0, 1747.0, 1790.0, 1845.0, 1908.0, 1954.0, 1981.0, 1976.0, 1945.0, 1894.0, 1835.0, 1785.0, 1756.0, 1746.0, 1760.0, 1805.0, 1864.0, 1929.0, 1977.0, 1998.0, 1984.0, 1941.0, 1878.0, 1814.0, 1764.0, 1738.0, 1739.0, 1771.0, 1831.0, 1901.0, 1958.0, 1991.0, 1991.0, 1961.0, 1909.0, 1845.0, 1788.0, 1745.0, 1733.0, 1749.0, 1792.0, 1858.0, 1927.0, 1974.0, 1998.0, 1988.0, 1947.0, 1886.0, 1821.0, 1769.0, 1741.0, 1746.0, 1776.0, 1825.0, 1889.0, 1948.0, 1986.0, 1997.0, 1971.0, 1917.0, 1853.0, 1794.0, 1750.0, 1732.0, 1747.0, 1788.0, 1844.0, 1910.0, 1965.0, 2000.0, 2001.0, 1966.0, 1903.0, 1829.0, 1766.0, 1726.0, 1723.0, 1762.0, 1818.0, 1883.0, 1945.0, 1990.0, 2003.0, 1981.0, 1929.0, 1867.0, 1804.0, 1754.0, 1728.0, 1735.0, 1776.0, 1835.0, 1901.0, 1955.0, 1996.0, 2007.0, 1978.0, 1920.0, 1842.0, 1775.0, 1724.0, 1711.0, 1736.0, 1790.0, 1861.0, 1925.0, 1982.0, 2010.0, 1997.0, 1952.0, 1880.0, 1806.0, 1744.0, 1712.0, 1716.0, 1754.0, 1827.0, 1904.0, 1963.0, 2004.0, 2011.0, 1981.0, 1922.0, 1847.0, 1780.0, 1732.0, 1716.0, 1730.0, 1779.0, 1851.0, 1925.0, 1979.0, 2010.0, 2005.0, 1968.0, 1901.0, 1822.0, 1753.0, 1708.0, 1704.0, 1735.0, 1800.0, 1879.0, 1953.0, 2004.0, 2021.0, 1997.0, 1940.0, 1860.0, 1783.0, 1722.0, 1695.0, 1708.0, 1757.0, 1830.0, 1915.0, 1980.0, 2014.0, 2014.0, 1974.0, 1908.0, 1828.0, 1757.0, 1707.0, 1693.0, 1722.0, 1787.0, 1865.0, 1947.0, 2005.0, 2025.0, 2007.0, 1952.0, 1875.0, 1796.0, 1732.0, 1699.0, 1706.0, 1747.0, 1821.0, 1905.0, 1978.0, 2024.0, 2030.0, 1998.0, 1934.0, 1851.0, 1770.0, 1714.0, 1691.0, 1711.0, 1772.0, 1856.0, 1943.0, 2008.0, 2037.0, 2026.0, 1977.0, 1899.0, 1811.0, 1734.0, 1688.0, 1686.0, 1726.0, 1801.0, 1886.0, 1967.0, 2023.0, 2039.0, 2017.0, 1956.0, 1868.0, 1782.0, 1708.0, 1675.0, 1688.0, 1742.0, 1826.0, 1917.0, 1990.0, 2034.0, 2033.0, 1990.0, 1913.0, 1822.0, 1738.0, 1679.0, 1665.0, 1700.0, 1781.0, 1880.0, 1967.0, 2031.0, 2050.0, 2028.0, 1962.0, 1875.0, 1783.0, 1709.0, 1673.0, 1678.0, 1730.0, 1812.0, 1906.0, 1990.0, 2044.0, 2050.0, 2011.0, 1930.0, 1835.0, 1747.0, 1684.0, 1658.0, 1682.0, 1752.0, 1851.0, 1950.0, 2033.0, 2072.0, 2058.0, 1993.0, 1899.0, 1794.0, 1711.0, 1663.0, 1664.0, 1712.0, 1801.0, 1902.0, 1996.0, 2057.0, 2070.0, 2036.0, 1955.0, 1853.0, 1754.0, 1681.0, 1648.0, 1668.0, 1737.0, 1838.0, 1946.0, 2033.0, 2079.0, 2073.0, 2015.0, 1919.0, 1812.0, 1713.0, 1655.0, 1649.0, 1688.0, 1771.0, 1879.0, 1984.0, 2063.0, 2087.0, 2056.0, 1977.0, 1877.0, 1772.0, 1685.0, 1643.0, 1655.0, 1715.0, 1814.0, 1926.0, 2024.0, 2081.0, 2089.0, 2045.0, 1951.0, 1836.0, 1728.0, 1656.0, 1633.0, 1667.0, 1748.0, 1865.0, 1982.0, 2069.0, 2109.0, 2088.0, 2013.0, 1900.0, 1786.0, 1691.0, 1636.0, 1636.0, 1691.0, 1786.0, 1903.0, 2014.0, 2090.0, 2107.0, 2063.0, 1965.0, 1844.0, 1730.0, 1645.0, 1613.0, 1641.0, 1722.0, 1836.0, 1961.0, 2070.0, 2126.0, 2118.0, 2045.0, 1930.0, 1802.0, 1690.0, 1620.0, 1612.0, 1664.0, 1763.0, 1881.0, 2004.0, 2094.0, 2127.0, 2091.0, 2001.0, 1882.0, 1761.0, 1660.0, 1610.0, 1623.0, 1698.0, 1815.0, 1942.0, 2053.0, 2119.0, 2121.0, 2061.0, 1950.0, 1819.0, 1696.0, 1615.0, 1594.0, 1638.0, 1737.0, 1867.0, 1991.0, 2087.0, 2129.0, 2111.0, 2028.0, 1904.0, 1766.0, 1653.0, 1593.0, 1596.0, 1668.0, 1789.0, 1931.0, 2050.0, 2124.0, 2139.0, 2085.0, 1981.0, 1846.0, 1714.0, 1616.0, 1580.0, 1613.0, 1711.0, 1843.0, 1982.0, 2089.0, 2143.0, 2127.0, 2051.0, 1930.0, 1795.0, 1670.0, 1595.0, 1586.0, 1648.0, 1761.0, 1900.0, 2032.0, 2117.0, 2145.0, 2108.0, 2009.0, 1873.0, 1735.0, 1631.0, 1582.0, 1603.0, 1689.0, 1821.0, 1963.0, 2081.0, 2145.0, 2143.0, 2073.0, 1956.0, 1820.0, 1693.0, 1608.0, 1582.0, 1626.0, 1729.0, 1868.0, 2009.0, 2113.0, 2154.0, 2122.0, 2029.0, 1895.0, 1754.0, 1639.0, 1576.0, 1584.0, 1660.0, 1783.0, 1926.0, 2059.0, 2144.0, 2162.0, 2104.0, 1979.0, 1834.0, 1698.0, 1601.0, 1565.0, 1606.0, 1711.0, 1850.0, 1994.0, 2105.0, 2160.0, 2146.0, 2062.0, 1926.0, 1778.0, 1651.0, 1572.0, 1566.0, 1636.0, 1760.0, 1909.0, 2048.0, 2141.0, 2167.0, 2121.0, 2018.0, 1869.0, 1725.0, 1615.0, 1569.0, 1593.0, 1684.0, 1819.0, 1965.0, 2088.0, 2154.0, 2152.0, 2080.0, 1953.0, 1802.0, 1666.0, 1580.0, 1563.0, 1618.0, 1729.0, 1874.0, 2017.0, 2116.0, 2161.0, 2131.0, 2034.0, 1891.0, 1736.0, 1617.0, 1556.0, 1569.0, 1652.0, 1786.0, 1942.0, 2077.0, 2160.0, 2165.0, 2097.0, 1974.0, 1822.0, 1675.0, 1577.0, 1549.0, 1600.0, 1716.0, 1865.0, 2013.0, 2121.0, 2171.0, 2150.0, 2058.0, 1921.0, 1767.0, 1635.0, 1562.0, 1566.0, 1645.0, 1774.0, 1926.0, 2062.0, 2148.0, 2166.0, 2113.0, 1995.0, 1846.0, 1701.0, 1591.0, 1556.0, 1596.0, 1705.0, 1845.0, 1995.0, 2112.0, 2170.0, 2153.0, 2064.0, 1922.0, 1768.0, 1635.0, 1555.0, 1554.0, 1626.0, 1755.0, 1907.0, 2049.0, 2149.0, 2180.0, 2129.0, 2015.0, 1861.0, 1711.0, 1599.0, 1547.0, 1575.0, 1676.0, 1819.0, 1974.0, 2104.0, 2172.0, 2162.0, 2077.0, 1940.0, 1782.0, 1647.0, 1564.0, 1549.0, 1616.0, 1745.0, 1899.0, 2043.0, 2143.0, 2176.0, 2135.0, 2027.0, 1876.0, 1723.0, 1606.0, 1549.0, 1567.0, 1659.0, 1805.0, 1962.0, 2094.0, 2171.0, 2170.0, 2091.0, 1951.0, 1792.0, 1647.0, 1559.0, 1547.0, 1608.0, 1734.0, 1893.0, 2042.0, 2145.0, 2177.0, 2136.0, 2028.0, 1880.0, 1726.0, 1604.0, 1548.0, 1565.0, 1652.0, 1798.0, 1961.0, 2099.0, 2177.0, 2176.0, 2096.0, 1960.0, 1798.0, 1650.0, 1553.0, 1532.0, 1597.0, 1718.0, 1877.0, 2034.0, 2145.0, 2184.0, 2144.0, 2040.0, 1890.0, 1733.0, 1605.0, 1543.0, 1562.0, 1651.0, 1789.0, 1949.0, 2091.0, 2179.0, 2185.0, 2110.0, 1971.0, 1808.0, 1658.0, 1564.0, 1544.0, 1603.0, 1721.0, 1872.0, 2027.0, 2143.0, 2194.0, 2162.0, 2056.0, 1899.0, 1731.0, 1601.0, 1533.0, 1544.0, 1635.0, 1780.0, 1950.0, 2100.0, 2188.0, 2195.0, 2119.0, 1978.0, 1815.0, 1667.0, 1563.0, 1535.0, 1586.0, 1709.0, 1871.0, 2033.0, 2153.0, 2198.0, 2163.0, 2056.0, 1900.0, 1734.0, 1600.0, 1531.0, 1541.0, 1628.0, 1778.0, 1949.0, 2101.0, 2193.0, 2201.0, 2127.0, 1984.0, 1816.0, 1664.0, 1559.0, 1529.0, 1578.0, 1701.0, 1864.0, 2029.0, 2152.0, 2208.0, 2181.0, 2072.0, 1904.0, 1732.0, 1591.0, 1519.0, 1528.0, 1620.0, 1770.0, 1945.0, 2105.0, 2202.0, 2213.0, 2138.0, 1993.0, 1813.0, 1651.0, 1540.0, 1506.0, 1563.0, 1693.0, 1866.0, 2036.0, 2160.0, 2211.0, 2181.0, 2080.0, 1918.0, 1739.0, 1594.0, 1517.0, 1524.0, 1615.0, 1771.0, 1950.0, 2112.0, 2210.0, 2222.0, 2149.0, 2005.0, 1825.0, 1652.0, 1534.0, 1498.0, 1556.0, 1690.0, 1865.0, 2041.0, 2169.0, 2224.0, 2196.0, 2088.0, 1923.0, 1741.0, 1590.0, 1510.0, 1517.0, 1610.0, 1765.0, 1944.0, 2105.0, 2207.0, 2226.0, 2156.0, 2009.0, 1827.0, 1654.0, 1527.0, 1489.0, 1545.0, 1681.0, 1861.0, 2041.0, 2176.0, 2232.0, 2198.0, 2084.0, 1911.0, 1729.0, 1576.0, 1494.0, 1504.0, 1599.0, 1761.0, 1946.0, 2114.0, 2222.0, 2245.0, 2174.0, 2025.0, 1836.0, 1658.0, 1529.0, 1481.0, 1534.0, 1673.0, 1860.0, 2048.0, 2189.0, 2249.0, 2216.0, 2098.0, 1919.0, 1727.0, 1577.0, 1493.0, 1499.0, 1592.0, 1756.0, 1945.0, 2117.0, 2229.0, 2254.0, 2179.0, 2026.0, 1833.0, 1651.0, 1521.0, 1476.0, 1520.0, 1655.0, 1845.0, 2043.0, 2191.0, 2257.0, 2225.0, 2104.0, 1927.0, 1737.0, 1577.0, 1489.0, 1491.0, 1583.0, 1748.0, 1945.0, 2121.0, 2232.0, 2251.0, 2181.0, 2030.0, 1833.0, 1648.0, 1513.0, 1467.0, 1525.0, 1659.0, 1847.0, 2043.0, 2191.0, 2260.0, 2231.0, 2109.0, 1925.0, 1726.0, 1565.0, 1476.0, 1482.0, 1577.0, 1737.0, 1936.0, 2116.0, 2240.0, 2269.0, 2194.0, 2037.0, 1836.0, 1644.0, 1504.0, 1456.0, 1516.0, 1656.0, 1844.0, 2041.0, 2193.0, 2263.0, 2234.0, 2117.0, 1939.0, 1739.0, 1571.0, 1475.0, 1472.0, 1567.0, 1736.0, 1932.0, 2117.0, 2244.0, 2273.0, 2197.0, 2041.0, 1839.0, 1643.0, 1502.0, 1455.0, 1509.0, 1648.0, 1839.0, 2035.0, 2189.0, 2266.0, 2242.0, 2123.0, 1939.0, 1734.0, 1568.0, 1471.0, 1469.0, 1563.0, 1731.0, 1937.0, 2125.0, 2250.0, 2279.0, 2203.0, 2046.0, 1841.0, 1645.0, 1501.0, 1445.0, 1494.0, 1631.0, 1830.0, 2037.0, 2193.0, 2269.0, 2246.0, 2129.0, 1947.0, 1747.0, 1577.0, 1475.0, 1468.0, 1562.0, 1728.0, 1931.0, 2117.0, 2251.0, 2270.0, 2194.0, 2044.0, 1846.0, 1653.0, 1508.0, 1453.0, 1498.0, 1634.0, 1825.0, 2028.0, 2192.0, 2276.0, 2257.0, 2133.0, 1947.0, 1742.0, 1571.0, 1472.0, 1471.0, 1566.0, 1732.0, 1933.0, 2117.0, 2242.0, 2273.0, 2200.0, 2042.0, 1843.0, 1654.0, 1515.0, 1458.0, 1501.0, 1632.0, 1822.0, 2024.0, 2183.0, 2263.0, 2244.0, 2134.0, 1950.0, 1747.0, 1575.0, 1472.0, 1464.0, 1557.0, 1729.0, 1931.0, 2116.0, 2239.0, 2268.0, 2200.0, 2047.0, 1843.0, 1648.0, 1507.0, 1451.0, 1498.0, 1636.0, 1825.0, 2025.0, 2179.0, 2256.0, 2234.0, 2124.0, 1943.0, 1737.0, 1567.0, 1474.0, 1475.0, 1568.0, 1731.0, 1925.0, 2103.0, 2225.0, 2260.0, 2194.0, 2047.0, 1851.0, 1656.0, 1517.0, 1466.0, 1514.0, 1647.0, 1834.0, 2030.0, 2179.0, 2249.0, 2225.0, 2110.0, 1936.0, 1743.0, 1582.0, 1492.0, 1488.0, 1577.0, 1736.0, 1925.0, 2099.0, 2211.0, 2235.0, 2169.0, 2028.0, 1845.0, 1663.0, 1525.0, 1474.0, 1525.0, 1661.0, 1844.0, 2032.0, 2174.0, 2241.0, 2212.0, 2099.0, 1925.0, 1737.0, 1581.0, 1494.0, 1502.0, 1595.0, 1751.0, 1933.0, 2097.0, 2207.0, 2230.0, 2162.0, 2016.0, 1833.0, 1660.0, 1534.0, 1487.0, 1536.0, 1664.0, 1844.0, 2029.0, 2170.0, 2227.0, 2195.0, 2079.0, 1908.0, 1731.0, 1593.0, 1518.0, 1524.0, 1614.0, 1770.0, 1947.0, 2104.0, 2198.0, 2209.0, 2133.0, 1989.0, 1820.0, 1657.0, 1549.0, 1515.0, 1563.0, 1690.0, 1861.0, 2038.0, 2167.0, 2219.0, 2182.0, 2066.0, 1901.0, 1727.0, 1592.0, 1530.0, 1550.0, 1642.0, 1791.0, 1961.0, 2109.0, 2196.0, 2198.0, 2118.0, 1973.0, 1801.0, 1647.0, 1550.0, 1533.0, 1594.0, 1715.0, 1880.0, 2041.0, 2158.0, 2205.0, 2163.0, 2046.0, 1885.0, 1721.0, 1593.0, 1537.0, 1567.0, 1670.0, 1816.0, 1978.0, 2115.0, 2187.0, 2178.0, 2092.0, 1951.0, 1785.0, 1640.0, 1556.0, 1547.0, 1618.0, 1746.0, 1900.0, 2049.0, 2155.0, 2190.0, 2141.0, 2021.0, 1863.0, 1707.0, 1591.0, 1546.0, 1579.0, 1685.0, 1831.0, 1989.0, 2117.0, 2181.0, 2162.0, 2067.0, 1924.0, 1767.0, 1640.0, 1567.0, 1570.0, 1639.0, 1770.0, 1923.0, 2061.0, 2151.0, 2164.0, 2102.0, 1984.0, 1834.0, 1693.0, 1590.0, 1556.0, 1598.0, 1712.0, 1865.0, 2018.0, 2129.0, 2176.0, 2144.0, 2042.0, 1895.0, 1741.0, 1620.0, 1559.0, 1579.0, 1669.0, 1803.0, 1952.0, 2082.0, 2155.0, 2157.0, 2086.0, 1963.0, 1815.0, 1680.0, 1594.0, 1575.0, 1630.0, 1743.0, 1891.0, 2031.0, 2131.0, 2163.0, 2123.0, 2022.0, 1879.0, 1732.0, 1628.0, 1583.0, 1608.0, 1697.0, 1827.0, 1970.0, 2089.0, 2150.0, 2139.0, 2066.0, 1943.0, 1798.0, 1671.0, 1592.0, 1588.0, 1655.0, 1774.0, 1916.0, 2043.0, 2126.0, 2147.0, 2096.0, 1989.0, 1856.0, 1721.0, 1619.0, 1575.0, 1612.0, 1710.0, 1844.0, 1981.0, 2087.0, 2138.0, 2120.0, 2036.0, 1915.0, 1781.0, 1670.0, 1603.0, 1601.0, 1666.0, 1778.0, 1915.0, 2039.0, 2119.0, 2136.0, 2080.0, 1973.0, 1839.0, 1713.0, 1621.0, 1587.0, 1621.0, 1719.0, 1853.0, 1984.0, 2085.0, 2128.0, 2105.0, 2028.0, 1909.0, 1778.0, 1673.0, 1610.0, 1610.0, 1671.0, 1784.0, 1916.0, 2037.0, 2112.0, 2127.0, 2071.0, 1966.0, 1837.0, 1713.0, 1628.0, 1597.0, 1632.0, 1724.0, 1854.0, 1983.0, 2080.0, 2122.0, 2101.0, 2020.0, 1899.0, 1777.0, 1677.0, 1620.0, 1625.0, 1683.0, 1786.0, 1913.0, 2029.0, 2108.0, 2122.0, 2072.0, 1971.0, 1845.0, 1726.0, 1639.0, 1611.0, 1641.0, 1720.0, 1838.0, 1965.0, 2066.0, 2114.0, 2096.0, 2021.0, 1907.0, 1781.0, 1683.0, 1627.0, 1632.0, 1690.0, 1786.0, 1905.0, 2015.0, 2087.0, 2103.0, 2059.0, 1965.0, 1847.0, 1731.0, 1648.0, 1620.0, 1654.0, 1734.0, 1841.0, 1956.0, 2049.0, 2095.0, 2087.0, 2024.0, 1920.0, 1803.0, 1699.0, 1641.0, 1635.0, 1689.0, 1783.0, 1891.0, 1989.0, 2061.0, 2088.0, 2056.0, 1971.0, 1861.0, 1754.0, 1673.0, 1641.0, 1664.0, 1738.0, 1839.0, 1943.0, 2028.0, 2073.0, 2067.0, 2008.0, 1909.0, 1800.0, 1711.0, 1659.0, 1653.0, 1696.0, 1785.0, 1889.0, 1982.0, 2046.0, 2066.0, 2036.0, 1963.0, 1866.0, 1768.0, 1693.0, 1659.0, 1676.0, 1736.0, 1835.0, 1940.0, 2021.0, 2062.0, 2055.0, 1998.0, 1913.0, 1814.0, 1729.0, 1675.0, 1669.0, 1709.0, 1786.0, 1889.0, 1980.0, 2037.0, 2049.0, 2019.0, 1949.0, 1858.0, 1772.0, 1703.0, 1674.0, 1688.0, 1750.0, 1838.0, 1935.0, 2008.0, 2038.0, 2027.0, 1974.0, 1895.0, 1807.0, 1737.0, 1699.0, 1699.0, 1741.0, 1812.0, 1894.0, 1968.0, 2019.0, 2022.0, 2003.0, 1932.0, 1848.0, 1773.0, 1719.0, 1702.0, 1726.0, 1783.0, 1859.0, 1933.0, 1991.0, 2017.0, 2005.0, 1956.0, 1878.0, 1802.0, 1739.0, 1710.0, 1715.0, 1760.0, 1827.0, 1900.0, 1962.0, 2003.0, 2006.0, 1971.0, 1911.0, 1839.0, 1779.0, 1737.0, 1727.0, 1752.0, 1804.0, 1870.0, 1933.0, 1981.0, 1999.0, 1988.0, 1942.0, 1876.0, 1802.0, 1751.0, 1727.0, 1741.0, 1782.0, 1843.0, 1912.0, 1964.0, 1992.0, 1985.0, 1950.0, 1897.0, 1829.0, 1770.0, 1742.0, 1746.0, 1777.0, 1829.0, 1889.0, 1942.0, 1973.0, 1981.0, 1958.0, 1910.0, 1850.0, 1798.0, 1757.0, 1744.0, 1765.0, 1807.0, 1861.0];

#print(length(t))
# create an empty string to read values
bc = ""

# turn on interactive mode and create figure
ion()
fig = figure(figsize=(10,8))

# opne serial port and define sample size
ser = SerialPort("/dev/ttyACM2", 115200)

while true
    # write 'c' to sedn chipr and get samples
    write(ser, "b'c'")
    while bytesavailable(ser) < 1
        continue
    end
    sleep(0.1)
    read = readavailable(ser) # empty buffer

    # write 'p' to print buffer to serial port
    write(ser, "b'p'")
    while bytesavailable(ser) < 1
        continue
    end

    a = zeros()
    global bc = ""
    # exit loop when serial buffer is empty
    while true
        if bytesavailable(ser) < 1
            sleep(0.005)

            if bytesavailable(ser) < 1
                break
            end
        end
        global bc = string(bc,readavailable(ser));
    end

    # split buffer string into array
    a = split(bc, "\r\n")
    # println(a)

    # convert array of stirng to array of ints
    a1 = zeros(length(a))
    for i = 1:length(a)-1
        try
            a1[i] = parse(Int, a[i])
        catch e
            println("Array not expected length...retrying...")
        end
    end

    # write 'p' to print buffer to serial port
    write(ser, "b'a'")
    while bytesavailable(ser) < 1
        continue
    end

    a = zeros()
    global bc = ""
    # exit loop when serial buffer is empty
    while true
        if bytesavailable(ser) < 1
            sleep(0.005)

            if bytesavailable(ser) < 1
                break
            end
        end
        global bc = string(bc,readavailable(ser));
    end

    # split buffer string into array
    a = split(bc, "\r\n")

    # convert array of stirng to array of ints
    a2 = zeros(length(a))
    for i = 1:length(a)-1
        try
            a2[i] = parse(Int, a[i])
        catch e
            println("Array not expected length...retrying...")
        end
    end
    print("length of a1:")
    println(length(a1))
    print("length of a2:")
    println(length(a2))

    # only plot if all values are collected
    if ((length(a1) >= sampleSize)  && (length(a2) >= sampleSize))
        # scale digital waveform to voltage
        # a1 = a1 .* (3.3/(4096))
        a1 = a1[1:sampleSize]
        rx1 = a1;

        # a2 = a2 .* (3.3/(4096))
        a2 = a2[1:sampleSize]
        rx2 = a2;

        #Init the matched filter and pad it
        s_mf = size(matched_filter);
        padding = SAMPLES-s_mf[1];
        pad = zeros(padding);
        paddedfilter = vcat(matched_filter, pad);

        #Get rid of offset
        #variables autoadjust to find chirp band
        band = Array{Any}(undef, SAMPLES)
        bandstart1 = (0.05*SAMPLES);
        bandstop1 = bandstart1+bandstart1;
        bandstop2 = SAMPLES-bandstart1;
        bandstart2 = SAMPLES - 2*bandstart1;
        for i in range(1, stop = SAMPLES)
            if ((i>=bandstart1 && i<= bandstop1) || (i>=bandstart2 && i<=bandstop2))
                band[i] = 1;
            else
                band[i] = 0;
            end
        end
        RX1 = fft(rx1);
        RX1 = RX1.*band;
        RX2 = fft(rx2);
        RX2 = RX2.*band;

        #Perform matched filtering
        FILTER = fft(paddedfilter);
        H = conj(FILTER);
        MF1 = RX1.*H;
        MF2 = RX2.*H;
        mf1 = ifft(MF1);
        mf1 = real(mf1);
        mf2 = ifft(MF2);
        mf2 = real(mf2);

        #Get analytic and baseband
        ANA1 = 2 .*MF1;
        ANA2 = 2 .*MF2;
        neg_freq_range = Int(SAMPLES/2):SAMPLES;
        ANA1[neg_freq_range].=0;
        ANA2[neg_freq_range].=0;
        ana1 = ifft(ANA1);
        ana2 = ifft(ANA2);

        #Get basebanded signals
        j=im;
        bb1 = ana1.*exp.(-j*2*pi*40000*t);    #The basebanded signal from receiver 1
        bb2 = ana2.*exp.(-j*2*pi*40000*t);    #The basebanded signal from receiver 2

        # Base band compensated signals
        bb1_comp = bb1.* (r).^2
        bb2_comp = bb2.* (r).^2

        #Peak detection: Uses threshold value to find peak
        #Takes average values to attempt to avoid false positives (check if necessary, may slow code)\
        lobes1 = zeros(SAMPLES)         #The phases for peaks from first receiver, to be filled
        lobes2 = zeros(SAMPLES);        #The phases for peaks from second receiver, to be filled
        global counter1 = 0;       #Counts main lobes detected in bb1
        global counter2 = 0;       #Counts main lobes detected in bb2


        global increasing = false
        global inc = 0
        for i in range(1, stop = SAMPLES-1)
            global increasing
            global counter1
            global inc
            if  (abs.(bb1_comp[i]) < abs.(bb1_comp[i+1]))
                increasing =true
                inc+=1
            elseif (abs.(bb1_comp[i]) > abs.(bb1_comp[i+1])) && (increasing==true) && ((i<4350 && abs.(bb1_comp[i])>THRESHOLD1)||(i>4350 && abs.(bb1_comp[i])>THRESHOLD)) && inc>RES
                increasing = false
                counter1 += 1
                inc = 0
                lobes1[i] = abs.(bb1_comp[i]);
            end
        end

        global inc = 0
        for i in range(1, stop = SAMPLES-1)
            global increasing
            global counter2
            global inc
            if  (abs.(bb2_comp[i]) < abs.(bb2_comp[i+1]))
                inc += 1
                increasing =true
            elseif (abs.(bb2_comp[i]) > abs.(bb2_comp[i+1])) && (increasing==true) && ((i<4350 && abs.(bb2_comp[i])>THRESHOLD1)||(i>4350 && abs.(bb2_comp[i])>THRESHOLD)) && inc>RES
                increasing = false
                inc =0
                counter2 += 1
                lobes2[i] = abs.(bb2_comp[i]);
            end
        end
        #Get the phase differences

        smallest = min(counter1, counter2)
        indices1 = Array{Int}(undef, smallest)
        global num = 1
        for i in range(1, stop=SAMPLES)
            global num
            if (num > smallest)
                break
            elseif (lobes1[i] != 0)
                indices1[num] = i
                num+=1
            end
        end

        indices2 = Array{Int}(undef, smallest)
        num = 1
        for i in range(1, stop=SAMPLES)
            global num
            if (num > smallest)
                break
            elseif (lobes2[i] != 0)
                indices2[num] = i
                num+=1
            end
        end

        # println(indices1)
        # println()
        # println(indices2)

        delta_psi = Array{Any}(undef, smallest);    #Assuming they have same number of peaks
        vectors1 = Array{Any}(undef, smallest);
        vectors2 = Array{Any}(undef, smallest);
        num=1
        for i in indices1
            global num
            vectors1[num] = bb1[i];
            num +=1
            #delta_psi[i] = angle(lobes1[i].*conj(lobes2[i]));
        end
        #println(vectors1)

        num=1
        for i in indices2
            global num
            vectors2[num] = bb2[i];
            num +=1
        end

        for i=1:smallest
            delta_psi[i] = angle(vectors1[i].*conj(vectors2[i]));
        end

        #println(delta_psi)
        #println(vectors2)

        #Get athe angles
        angles = Array{Any}(undef, smallest);
        for i in range(1, stop=smallest)
            angles[i] = (asin.(((C/FREQ)*(delta_psi[i] +2*pi))/(2*pi*DIST)))
        end

        # println(angles)

        distances = indices1.*(10/SAMPLES) #only uses one transducer

        y = distances.*sin.(angles)
        x = distances.*cos.(angles)


        # plot both received waveform and matched filter response
        subplot(411)
        cla()
        # ylabel("Voltage (V)")
        title("Received signal matched filter response")
        plot(r, abs.(bb1))
        # ylim(0, 3.3)
        plot(r, abs.(bb2))
        xlim(0,10)

        subplot(412)
        cla()
        title("Range compensated")
        # ylabel("Voltage (V)")
        # title("Received signal")
        plot(r[1:26000], abs.(bb1_comp)[1:26000])
        # ylim(0, 3.3)
        plot(r[1:26000], abs.(bb2_comp)[1:26000])
        xlim(0,10)


        subplot(413)
        cla()
        xlabel("distance (m)")
        title("Phase difference (rads)")
        plot(r, angle.(bb1.*conj(bb2)))
        # plot(angle.(bb2))
        # plot(angle.(bb1))

        subplot(414)
        cla()
        # xlabel("distance (m)")
        # ylabel("Magnitude")
        # title("Range compensated")
        scatter(x,y)


        angles = Array{Any}(undef, smallest);
        for i in range(1, stop=smallest)
            angles[i] = (asin.(((C/FREQ)*(delta_psi[i] -2*pi))/(2*pi*DIST)))
        end

        # println(angles)

        distances = indices1.*(10/SAMPLES) #only uses one transducer

        y = distances.*sin.(angles)
        x = distances.*cos.(angles)
        scatter(x,y)

        angles = Array{Any}(undef, smallest);
        for i in range(1, stop=smallest)
            angles[i] = (asin.(((C/FREQ)*(delta_psi[i]))/(2*pi*DIST)))
        end

        # println(angles)

        distances = indices1.*(10/SAMPLES) #only uses one transducer

        y = distances.*sin.(angles)
        x = distances.*cos.(angles)
        scatter(x,y)
        xlim(0,10)
        ylim(-2,2)


    end
end

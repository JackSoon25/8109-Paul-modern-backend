USE crm;

-- =========================
-- Companies
-- =========================
INSERT INTO Companies (name, description) VALUES
('Northbridge Advisory Group', 'Independent financial advisory firm serving corporate and private clients'),
('Summit Ridge Wealth', 'Wealth management firm focused on long-term investment planning');

-- =========================
-- Departments
-- =========================
INSERT INTO Departments (name) VALUES
('Client Advisory'),
('Portfolio Management');

-- =========================
-- Employees
-- =========================
INSERT INTO Employees (first_name, last_name, department_id) VALUES
('Daniel', 'Hughes', 1),
('Rebecca', 'Morgan', 2),
('Thomas', 'Ellis', 1);

-- =========================
-- Products (realistic, overlapping types)
-- =========================
INSERT INTO Products (name, description) VALUES
(
  'HorizonPath 2045',
  'Target-date retirement portfolio focused on long-term capital growth with integrated ESG screening and automated risk rebalancing.'
),
(
  'GreenYield Select',
  'Income-oriented ESG investment designed to deliver stable quarterly income with controlled downside risk.'
),
(
  'Atlas Core Growth',
  'Globally diversified growth strategy using tax-efficient allocation to maximize long-term after-tax returns.'
),
(
  'SilverAnchor Income',
  'Capital-preservation-focused income product designed for near- and post-retirement investors.'
),
(
  'NovaEdge Equity Plus',
  'Actively managed equity growth portfolio offering diversification with enhanced ESG exposure.'
),
(
  'ShieldBond Advantage',
  'Defensive fixed-income strategy emphasizing capital protection, tax efficiency, and predictable income.'
);

-- =========================
-- Customers
-- Each customer has EXACTLY ONE employee
-- =========================
INSERT INTO Customers (first_name, last_name, email, company_id, employee_id, date_joined, annual_salary) VALUES
('Andrew', 'Collins', 'andrew.collins@northbridge.com', 1, 1, "2020-01-01", 100000),
('Melissa', 'Turner', 'melissa.turner@northbridge.com', 1, 1, "2020-03-01", 200000),
('Robert', 'Kim', 'robert.kim@summitridge.com', 2, 2, "2022-01-01", 50000),
('Natalie', 'Brooks', 'natalie.brooks@summitridge.com', 2, 2, "2023-01-05", 500000),
('Ethan', 'Price', 'ethan.price@northbridge.com', 1, 3, "2019-01-01", 90000),
('Sophia', 'Lopez', 'sophia.lopez@summitridge.com', 2, 3, "2025-06-30", 70000);

-- =========================
-- Customer to Product (many-to-many)
-- =========================
INSERT INTO CustomerProduct (customer_id, product_id) VALUES
-- Andrew Collins
(1, 1),
(1, 3),
(1, 5),

-- Melissa Turner
(2, 2),
(2, 4),

-- Robert Kim
(3, 3),
(3, 6),

-- Natalie Brooks
(4, 1),
(4, 2),
(4, 5),

-- Ethan Price
(5, 3),
(5, 5),

-- Sophia Lopez
(6, 1),
(6, 4),
(6, 6);

-- =========================
-- Employee to Product (many-to-many)
-- =========================
INSERT INTO EmployeeProduct (employee_id, product_id) VALUES
-- Daniel Hughes
(1, 1),
(1, 3),
(1, 5),

-- Rebecca Morgan
(2, 2),
(2, 4),
(2, 6),

-- Thomas Ellis
(3, 1),
(3, 3),
(3, 6);

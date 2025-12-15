const { Sequelize } = require('sequelize');

// PostgreSQL Configuration
const sequelize = new Sequelize(process.env.DATABASE_URL || 'postgresql://localhost:5432/glamora', {
  dialect: 'postgres',
  logging: process.env.NODE_ENV === 'development' ? console.log : false,
  pool: {
    max: 5,
    min: 0,
    acquire: 30000,
    idle: 10000
  }
});

// Test connection
const testConnection = async () => {
  try {
    await sequelize.authenticate();
    console.log('✅ Database connection established successfully');
  } catch (error) {
    console.error('❌ Unable to connect to database:', error.message);
    process.exit(1);
  }
};

testConnection();

module.exports = sequelize;

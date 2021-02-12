const chai = require('chai');
const chaiHttp = require ("chai-http");
const app = require('../app');

chai.should();
chai.use(chaiHttp);

describe('Test /', () => {
  it('Get request to / returns Hello World', (done) => {
    chai.request(app)
        .get('/')
        .end((err, response) => {
            response.should.have.status(200);
            response.text.should.be.eql('Hello World');
        done();
        });
  });
});
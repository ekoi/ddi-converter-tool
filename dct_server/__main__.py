#!/usr/bin/env python3

import connexion
from flask_cors import CORS
import logging
import os

from dct_server import encoder
from dct_server import config


def main():
    app = connexion.App(__name__, specification_dir='./swagger/')
    app.app.json_encoder = encoder.JSONEncoder
    app.add_api('swagger.yaml', arguments={'title': 'DDI Converter Tool'}, pythonic_params=True)
    logging.basicConfig(filename=config.DDI_CONVERTER_TOOL_LOG_FILE, level=logging.DEBUG,
                        format='%(asctime)s %(levelname)s %(name)s %(threadName)s : %(message)s')

    try:
        env_dv_base_url = os.environ['DV_BASE_URL']
        config.DATAVERSE_BASE_URL = env_dv_base_url
        logging.debug('Using dataverse base url environment: ' + config.DATAVERSE_BASE_URL)
    except KeyError:
        logging.debug('Using dataverse base url from config.py: '+ config.DATAVERSE_BASE_URL)

    # add CORS support
    CORS(app.app)
    app.run(port=8520, debug=config.DDI_CONVERTER_TOOL_DEBUG, threaded=True)

if __name__ == '__main__':
    main()

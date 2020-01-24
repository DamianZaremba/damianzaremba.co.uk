#!/usr/bin/env python
"""
Simple script to take a post in a pending state and publish it.
Deals with renaming all assets to the right date.
"""
import time
import yaml
import re
import os.path
import logging
import shutil
import sys

logger = logging.getLogger(__name__)


def process_file(path):
    with open(path, "r") as fh:
        sections = fh.read().split("---")
        if len(sections) < 3:
            logger.warning("Did not understand the contents of {}".format(path))
            return False

        try:
            metadata = yaml.load(sections[1])
        except Exception as e:
            logger.error("could not load metadata block for {}: {}".format(path, e))
            return False

        if metadata.get("status") == "pending":
            return publish(path, metadata, "---".join(sections[3:]))

    return False


def publish(path, metadata, text):
    src_name = re.sub("\.(markdown|md)$", "", os.path.basename(path))

    # Setup the date if we don't have a date
    # If we do have a date, this does nothing
    if re.match("^[0-9]{4}\-[0-9]{2}\-[0-9]{2}\-", src_name):
        dst_name = src_name
    else:
        dst_name = "{}-{}".format(time.strftime("%Y-%m-%d"), src_name)

    metadata.pop("status", None)
    metadata_block = "---{}---".format(yaml.dump(metadata))

    # Output new file, remove old file
    target_path = os.path.join("content", "_posts", "{}.markdown".format(dst_name))
    logger.info("Promoting {} to {}".format(path, target_path))
    with open(target_path, "w") as fh:
        fh.write("{}\n{}".format(metadata_block, text))
        fh.close()
    os.unlink(path)

    # Now move any postfiles
    src_dir = os.path.join("content", "_postfiles", src_name)
    dst_dir = os.path.join("content", "_postfiles", dst_name)
    if os.path.isdir(src_dir):
        logger.info("Moving postfiles from {} to {}".format(src_dir, dst_dir))
        shutil.move(src_dir, dst_dir)

    return True


def main():
    logging.basicConfig(stream=sys.stdout)

    for source_dir in ["content/_drafts/singles/"]:
        if os.path.isdir(source_dir):
            for path, dirs, files in os.walk(source_dir):
                for file in files:
                    path = os.path.join(source_dir, file)
                    logger.info("Processing {}".format(path))
                    if process_file(path):
                        return


if __name__ == "__main__":
    main()

import subprocess
import os
from flask import Flask, render_template, redirect, request
from flask_mysqldb import MySQL
from flask import Blueprint, render_template, request, redirect
from flask_mysqldb import MySQL
from MySQLdb import IntegrityError
from datetime import date